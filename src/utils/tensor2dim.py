import sys
import argparse
import re

from torch.utils.serialization import load_lua

def getShape(idx, in_file, mode):
    tensor = load_lua(in_file)
    if mode == "ilen":
        return idx + " " + tensor.shape[0]
    elif mode == "idim":
        return idx + " " + tensor.shape[1]
    else:
        pass

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('input_feat', type=str, default=False, nargs='?',
                        help='as SCP file')
    parser.add_argument('mode', type=str, default=False, nargs='?',
                        help='ilen or idim')
    args = parser.parse_args()

    scp_file = open(args.input_feat, "r")
    for line in scp_file:
        idx, in_file = line.split(" ")
        print(getShape(idx, in_file, args.mode))

if __name__ == '__main__':
    main()
