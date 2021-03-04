import asyncio

from config import TomlConfig
from console import NebulaShell


async def main(loop):
    config = TomlConfig("config.toml", "config.template.toml")
    shell = NebulaShell(loop)
    await shell.start()
    print("hello")



loop = asyncio.get_event_loop()
loop.run_until_complete(main(loop))
