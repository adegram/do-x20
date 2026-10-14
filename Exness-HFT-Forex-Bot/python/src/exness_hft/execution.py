from __future__ import annotations

from dataclasses import dataclass
from enum import Enum


class OrderState(str, Enum):
    IDLE = "IDLE"
    SIGNAL = "SIGNAL"
    REQUESTED = "REQUESTED"
    ENTRY_FILLED = "ENTRY_FILLED"
    EXIT_REQUESTED = "EXIT_REQUESTED"
    COMPLETE = "COMPLETE"
    UNCERTAIN = "UNCERTAIN"
    REJECTED = "REJECTED"


@dataclass
class OrderLifecycle:
    correlation_id: str
    state: OrderState = OrderState.IDLE
    ticket: int | None = None

    def signal(self) -> bool:
        if self.state is not OrderState.IDLE:
            return False
        self.state = OrderState.SIGNAL
        return True

    def submit_entry(self) -> None:
        if self.state is not OrderState.SIGNAL:
            raise ValueError("invalid entry submission")
        self.state = OrderState.REQUESTED

    def entry_result(self, ticket: int | None) -> None:
        if self.state is not OrderState.REQUESTED:
            raise ValueError("unexpected entry result")
        if ticket is None:
            self.state = OrderState.UNCERTAIN
        else:
            self.ticket, self.state = ticket, OrderState.ENTRY_FILLED

    def reconcile(self, found_ticket: int | None) -> None:
        if self.state is not OrderState.UNCERTAIN:
            raise ValueError("reconciliation only follows uncertainty")
        self.ticket = found_ticket
        self.state = OrderState.ENTRY_FILLED if found_ticket is not None else OrderState.REJECTED
