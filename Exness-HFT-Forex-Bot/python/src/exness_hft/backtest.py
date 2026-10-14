from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
from collections.abc import Sequence


@dataclass(frozen=True)
class Tick:
    timestamp: datetime
    bid: float
    ask: float


@dataclass(frozen=True)
class ExecutionCostModel:
    commission_per_lot_round_trip: float
    adverse_slippage_points: float
    point: float
    rejection_probability: float = 0.0

    def fill_price(self, side: int, observed_price: float) -> float:
        if side not in (-1, 1) or observed_price <= 0 or self.point <= 0:
            raise ValueError("invalid fill request")
        return observed_price + side * self.adverse_slippage_points * self.point


def validate_ticks(ticks: Sequence[Tick]) -> None:
    previous: datetime | None = None
    for tick in ticks:
        if tick.bid <= 0 or tick.ask <= tick.bid:
            raise ValueError("invalid bid/ask")
        if previous is not None and tick.timestamp <= previous:
            raise ValueError("timestamps must be strictly increasing and unique")
        previous = tick.timestamp
