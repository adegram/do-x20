from __future__ import annotations

from dataclasses import dataclass
from .config import RiskConfig


@dataclass(frozen=True)
class RiskDecision:
    approved: bool
    reason: str


class CircuitBreaker:
    """Deterministic entry gate; a breach remains latched until an explicit reset."""

    def __init__(self, config: RiskConfig, opening_equity: float) -> None:
        config.validate()
        if opening_equity <= 0:
            raise ValueError("opening equity must be positive")
        self.config = config
        self.opening_equity = opening_equity
        self.high_water_equity = opening_equity
        self.realized_today = 0.0
        self.consecutive_losses = 0
        self.halted_reason: str | None = None

    def update_closed_pnl(self, pnl: float, equity: float) -> None:
        self.realized_today += pnl
        self.consecutive_losses = self.consecutive_losses + 1 if pnl < 0 else 0
        self.high_water_equity = max(self.high_water_equity, equity)
        self._evaluate(equity)

    def _evaluate(self, equity: float) -> None:
        if equity <= 0:
            self.halted_reason = "invalid_equity"
        elif self.realized_today <= -self.opening_equity * self.config.max_daily_loss_fraction:
            self.halted_reason = "daily_loss_limit"
        elif (self.high_water_equity - equity) / self.high_water_equity >= self.config.max_drawdown_fraction:
            self.halted_reason = "drawdown_limit"
        elif self.consecutive_losses >= self.config.max_consecutive_losses:
            self.halted_reason = "consecutive_loss_limit"

    def approve_entry(self, *, equity: float, spread_points: float, latency_ms: int,
                      open_positions: int, stale: bool, live_gate_passed: bool) -> RiskDecision:
        self._evaluate(equity)
        if self.halted_reason:
            return RiskDecision(False, self.halted_reason)
        if stale:
            return RiskDecision(False, "stale_market_data")
        if not live_gate_passed:
            return RiskDecision(False, "execution_gate_not_passed")
        if open_positions >= self.config.max_open_positions:
            return RiskDecision(False, "max_open_positions")
        if spread_points > self.config.max_spread_points:
            return RiskDecision(False, "spread_limit")
        if latency_ms > self.config.max_latency_ms:
            return RiskDecision(False, "latency_limit")
        return RiskDecision(True, "approved")

    def reset_after_manual_review(self) -> None:
        self.halted_reason = None
        self.consecutive_losses = 0
