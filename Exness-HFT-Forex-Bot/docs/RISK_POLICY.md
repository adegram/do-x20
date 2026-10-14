# Risk policy

Initial defaults are deliberately conservative: 0.25% equity risk per trade, one managed open position, 2% daily loss stop, 5% drawdown stop, a 20-point spread cap, and a 10-point requested slippage cap. The EA rounds lot size down; if the broker minimum lot exceeds the calculated risk, it refuses the trade.

No martingale, grid, averaging-down, or loss multiplier is implemented. A daily-loss or drawdown breach latches the EA into a halt for that attachment/session; resolve open positions under the operator's documented emergency policy and restart only after review. `ManualEmergencyStop=true` blocks all new entries immediately.

Maximum spread, stop distance, and all values must be revalidated against the actual symbol/account before demo use. A requested slippage cap is not a fill guarantee.
