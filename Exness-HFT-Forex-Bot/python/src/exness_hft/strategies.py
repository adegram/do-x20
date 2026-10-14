from __future__ import annotations

from collections.abc import Sequence


def momentum_signal(mid_prices: Sequence[float], threshold_points: float, point: float) -> int:
    if len(mid_prices) < 2 or point <= 0:
        return 0
    delta = (mid_prices[-1] - mid_prices[-2]) / point
    return 1 if delta >= threshold_points else -1 if delta <= -threshold_points else 0


def mean_reversion_signal(mid_prices: Sequence[float], threshold_points: float, point: float) -> int:
    if len(mid_prices) < 3 or point <= 0:
        return 0
    reference = sum(mid_prices[:-1]) / (len(mid_prices) - 1)
    deviation = (mid_prices[-1] - reference) / point
    return -1 if deviation >= threshold_points else 1 if deviation <= -threshold_points else 0
