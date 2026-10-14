from __future__ import annotations

import math


def round_down_lot(lots: float, min_lot: float, max_lot: float, lot_step: float) -> float:
    if min_lot <= 0 or max_lot < min_lot or lot_step <= 0:
        raise ValueError("invalid symbol lot specification")
    if lots < min_lot:
        return 0.0
    rounded = math.floor((lots + 1e-12) / lot_step) * lot_step
    return round(min(rounded, max_lot), 8) if rounded >= min_lot else 0.0


def position_size(*, equity: float, risk_fraction: float, stop_points: float,
                  tick_value: float, tick_size_points: float, min_lot: float,
                  max_lot: float, lot_step: float, estimated_cost: float = 0.0) -> float:
    if min(equity, risk_fraction, stop_points, tick_value, tick_size_points) <= 0:
        raise ValueError("invalid sizing inputs")
    risk_cash = equity * risk_fraction - estimated_cost
    if risk_cash <= 0:
        return 0.0
    cost_per_lot = stop_points / tick_size_points * tick_value
    return round_down_lot(risk_cash / cost_per_lot, min_lot, max_lot, lot_step)
