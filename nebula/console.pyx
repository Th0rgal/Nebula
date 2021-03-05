import aioconsole

class UnknownCommandError(Exception):
    pass

class NebulaShell:

    def __init__(self, loop, client):
        self.loop = client
        self.client = client
        self.enabled = True

    async def start(self):
        self.print_welcome()
        while self.enabled:
            await self.handle_command(await aioconsole.ainput(">> "))

    async def handle_command(self, content):
        try:
            args = content.split(" ")
            commands = {
                ("help", "h"): self.print_help,
                ("balances", "bal", "b"): self.print_balances,
                ("exit", "e"): self.exit,
            }
            for labels in commands:
                if args[0] in labels:
                    commands[labels](args)
                    break
            else:
                raise UnknownCommandError
        except Exception as exception:
            print(f"/!\ An exception of type {type(exception)} has occured.")
            choice = await aioconsole.ainput("Type s to display it or anything else to resume: ")
            if choice == "s":
                print(exception)

    def print_welcome(self):
        print(
            "Nebula has been successfully started, this is an interactive"
            " shell designed  to assist you during binance pumps."
            " Type h for help."
        )

    def print_help(self, args):
        print(
            "Available commands:"
            "\n- [help, h] # print this help"
            "\n- [exit, e] # exit this shell"
        )

    def print_balances(self, args):
        print(str(self.client.cleaned_balances))

    def exit(self, args):
        self.enabled = False
