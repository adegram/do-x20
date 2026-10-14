import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parents[1] / "src"))

import unittest
from exness_hft.accounting import RoundTrip, TradeCounters
from exness_hft.execution import OrderLifecycle, OrderState
from exness_hft.sizing import position_size, round_down_lot
from exness_hft.strategies import momentum_signal, mean_reversion_signal


class CoreTests(unittest.TestCase):
    def test_lot_rounding_and_minimum_risk_rejection(self):
        self.assertEqual(round_down_lot(0.129, 0.01, 10, 0.01), 0.12)
        self.assertEqual(position_size(equity=100, risk_fraction=.001, stop_points=100, tick_value=1, tick_size_points=1, min_lot=.01, max_lot=1, lot_step=.01), 0.0)

    def test_net_pnl_does_not_double_count_spread(self):
        trade = RoundTrip(gross_pnl=10, commission=-2, swap=-1, spread_cost_estimate=3)
        self.assertEqual(trade.net_pnl, 7)

    def test_round_trip_count_requires_both_fills(self):
        counters = TradeCounters()
        counters.record_round_trip(True, False, False)
        counters.record_round_trip(True, True, True)
        self.assertEqual((counters.completed_round_trips, counters.reconciled_trades), (1, 1))

    def test_uncertain_order_is_reconciled_not_resent(self):
        order = OrderLifecycle("a")
        self.assertTrue(order.signal())
        self.assertFalse(order.signal())
        order.submit_entry(); order.entry_result(None); order.reconcile(44)
        self.assertEqual(order.state, OrderState.ENTRY_FILLED)

    def test_strategy_signals(self):
        self.assertEqual(momentum_signal([1.0, 1.0003], 2, .0001), 1)
        self.assertEqual(mean_reversion_signal([1.0, 1.0, 1.0005], 2, .0001), -1)
