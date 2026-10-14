#ifndef EXNESS_HFT_ORDER_MANAGER_MQH
#define EXNESS_HFT_ORDER_MANAGER_MQH
int CountManagedOpenOrders(int magic) {
   int count=0;
   for(int i=OrdersTotal()-1; i>=0; i--) if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      if(OrderMagicNumber()==magic && OrderSymbol()==Symbol() && (OrderType()==OP_BUY || OrderType()==OP_SELL)) count++;
   return(count);
}

bool HasManagedOrder(int magic, int ticket) {
   return(ticket>0 && OrderSelect(ticket,SELECT_BY_TICKET) && OrderMagicNumber()==magic && OrderSymbol()==Symbol());
}
#endif
