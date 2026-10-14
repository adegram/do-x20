import sys
from datetime import datetime, timedelta, timezone
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parents[1] / "src"))

import unittest
from exness_hft.backtest import ExecutionCostModel, Tick, validate_ticks


class BacktestTests(unittest.TestCase):
    def test_rejects_duplicate_and_invalid_ticks(self):
        t = datetime(2026, 1, 1, tzinfo=timezone.utc)
        with self.assertRaises(ValueError):
            validate_ticks([Tick(t, 1.0, 1.1), Tick(t, 1.0, 1.1)])
        with self.assertRaises(ValueError):
            validate_ticks([Tick(t, 1.1, 1.0)])

    def test_adverse_slippage_moves_against_side(self):
        model = ExecutionCostModel(7.0, 2, .0001)
        self.assertEqual(model.fill_price(1, 1.0), 1.0002)
        self.assertEqual(model.fill_price(-1, 1.0), .9998)
