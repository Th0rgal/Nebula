import asyncio

from config import TomlConfig
from console import NebulaShell
from client_wrapper import WrappedClient


async def main(loop):
    config = TomlConfig("config.toml", "config.template.toml")
    wrapped_client = WrappedClient(config.api_key, config.api_secret, config.proxy)
    await wrapped_client.load(loop)
    shell = NebulaShell(loop, wrapped_client)
    await shell.start()


loop = asyncio.get_event_loop()
loop.run_until_complete(main(loop))
