#!/usr/bin/env python3
import click
import mymodule


@click.command()
@click.option('-name', default='World', help='your name')
def main(name: str):
    mymodule.greetings(name)


if __name__ == '__main__':
    main()
