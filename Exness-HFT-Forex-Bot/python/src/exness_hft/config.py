from __future__ import annotations

from dataclasses import dataclass
from enum import Enum


class ExecutionMode(str, Enum):
    DRY_RUN = "DRY_RUN"
    DEMO = "DEMO"
    LIVE = "LIVE"


@dataclass(frozen=True)
class RiskConfig:
    risk_per_trade_fraction: float = 0.0025
    max_daily_loss_fraction: float = 0.02
    max_drawdown_fraction: float = 0.05
    max_open_positions: int = 1
    max_spread_points: float = 20.0
    max_slippage_points: float = 10.0
    max_consecutive_losses: int = 3
    max_latency_ms: int = 1000

    def validate(self) -> None:
        if not 0 < self.risk_per_trade_fraction <= 0.01:
            raise ValueError("risk_per_trade_fraction must be in (0, 0.01]")
        if not 0 < self.max_daily_loss_fraction <= 0.10:
            raise ValueError("max_daily_loss_fraction must be in (0, 0.10]")
        if not 0 < self.max_drawdown_fraction <= 0.25:
            raise ValueError("max_drawdown_fraction must be in (0, 0.25]")
        if self.max_open_positions < 1 or self.max_spread_points <= 0:
            raise ValueError("invalid position or spread limit")
