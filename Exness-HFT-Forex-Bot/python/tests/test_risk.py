import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parents[1] / "src"))

import unittest
from exness_hft.config import RiskConfig
from exness_hft.risk import CircuitBreaker


class RiskTests(unittest.TestCase):
    def setUp(self):
        self.config = RiskConfig(max_consecutive_losses=2, max_daily_loss_fraction=0.02)

    def test_spread_and_live_gate_reject(self):
        breaker = CircuitBreaker(self.config, 1000)
        self.assertFalse(breaker.approve_entry(equity=1000, spread_points=1, latency_ms=1, open_positions=0, stale=False, live_gate_passed=False).approved)
        self.assertEqual(breaker.approve_entry(equity=1000, spread_points=99, latency_ms=1, open_positions=0, stale=False, live_gate_passed=True).reason, "spread_limit")

    def test_daily_loss_latches(self):
        breaker = CircuitBreaker(self.config, 1000)
        breaker.update_closed_pnl(-20, 980)
        self.assertEqual(breaker.halted_reason, "daily_loss_limit")
        self.assertFalse(breaker.approve_entry(equity=980, spread_points=1, latency_ms=1, open_positions=0, stale=False, live_gate_passed=True).approved)

    def test_stale_data_rejected(self):
        breaker = CircuitBreaker(self.config, 1000)
        self.assertEqual(breaker.approve_entry(equity=1000, spread_points=1, latency_ms=1, open_positions=0, stale=True, live_gate_passed=True).reason, "stale_market_data")
