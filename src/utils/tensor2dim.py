import sys
import argparse
import re

from torch.utils.serialization import load_lua

def getShape(idx, in_file):
    tensor = load_lua(in_file)
    return idx, tensor.shape[0], tensor.shape[1]

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('input_feat', type=str, default=False, nargs='?',
                        help='as SCP file')
    parser.add_argument('output_len', type=str, default=False, nargs='?',
                        help='as SCP file')
    parser.add_argument('output_dim', type=str, default=False, nargs='?',
                        help='as SCP file')
    args = parser.parse_args()

    scp_file = open(args.input_feat, "r")
    len_file = open(args.output_len, "w")
    dim_file = open(args.output_dim, "w")
    for line in scp_file:
        idx, in_file = line.split(" ")
        idx, ilen, idim = getShape(idx, in_file)
        len_file.write(idx + " " + ilen + "\n")
        dim_file.write(idx + " " + idim + "\n")


if __name__ == '__main__':
    main()
