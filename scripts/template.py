#!/usr/bin/env python3
import argparse
import mymodule


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('-name', default='World', help='your name')
    args = parser.parse_args()
    return args


def main():
    args = parse_args()
    mymodule.greetings(args.name)


if __name__ == '__main__':
    main()
