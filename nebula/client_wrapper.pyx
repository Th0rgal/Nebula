import binance
from decimal import Decimal


class WrappedClient:
    def __init__(self, api_key, api_secret, proxy):
        self.client = binance.Client(api_key, api_secret, proxy=proxy)
        self.free_balances = {}
        self.orders = []

    async def load(self, loop):
        await self.client.load()
        account_data = await self.client.fetch_account_information()
        self.client.events.register_event(
            self.when_account_updates, "outboundAccountPosition"
        )
        loop.create_task(self.client.start_user_events_listener())
        for asset_section in account_data["balances"]:
            self.free_balances[asset_section["asset"]] = asset_section["free"]

    def when_account_updates(self, event):
        for balance in event.balances:
            self.free_balances[balance] = event.balances[balance]["free"]

    @property
    def free_btc_balance(self):
        return Decimal(self.free_balances["BTC"])

    def free_balance(self, coin):
        return Decimal(self.free_balances[coin])

    @property
    def cleaned_balances(self):
        balances = self.free_balances.copy()
        for balance in self.free_balances:
            if Decimal(self.free_balances[balance]) == Decimal(0):
                del balances[balance]
        return balances