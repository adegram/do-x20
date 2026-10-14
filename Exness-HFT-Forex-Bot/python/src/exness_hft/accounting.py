from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class RoundTrip:
    gross_pnl: float
    commission: float
    swap: float
    # Spread is informational only when gross_pnl originates from broker history.
    spread_cost_estimate: float = 0.0

    @property
    def net_pnl(self) -> float:
        return self.gross_pnl + self.commission + self.swap


@dataclass
class TradeCounters:
    signals: int = 0
    requests: int = 0
    accepted_orders: int = 0
    rejected_requests: int = 0
    entry_fills: int = 0
    exit_fills: int = 0
    completed_round_trips: int = 0
    reconciled_trades: int = 0

    def record_round_trip(self, entry_confirmed: bool, exit_confirmed: bool, reconciled: bool) -> None:
        if entry_confirmed:
            self.entry_fills += 1
        if exit_confirmed:
            self.exit_fills += 1
        if entry_confirmed and exit_confirmed:
            self.completed_round_trips += 1
        if reconciled and entry_confirmed and exit_confirmed:
            self.reconciled_trades += 1
