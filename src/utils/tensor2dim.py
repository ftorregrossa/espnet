#!/usr/bin/env python2

import sys
import argparse
import re

from torch.utils.serialization import load_lua

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('input_feat', type=str, default=False, nargs='?',
                        help='as SCP file')
    parser.add_argument('output_len', type=str, default=False, nargs='?',
                        help='as SCP file')
    parser.add_argument('output_dim', type=str, default=False, nargs='?',
                        help='as SCP file')
    args = parser.parse_args()

    if args.input_feat:
        scp_file = open(args.input_feat, "r")
    else:
        scp_file = sys.stdin
    output_len = open(args.output_len, "w")
    output_dim = open(args.output_dim, "w")
    for line in scp_file:
        idx, in_file = line.split(" ")
        tensor = load_lua(in_file.replace("\n", ""))
        ilen, idim = "%s %d" % (idx, tensor.shape[0]), "%s %d" % (idx, tensor.shape[1])
        output_len.write(ilen + "\n")
        output_dim.write(idim + "\n")
    output_len.flush()
    output_dim.flush()
    output_len.close()
    output_dim.close()

if __name__ == '__main__':
    main()
