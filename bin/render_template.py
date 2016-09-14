import sys, re
from subprocess import call

def get_args():
    import argparse

    parser = argparse.ArgumentParser(description='')
    parser.add_argument('template_name', type=str,
        help='template name')
    parser.add_argument('output', type=str,
        help='output filename')
    parser.add_argument('template_args', type=str, nargs='*',
        help='arguments to pass to template')
    parser.add_argument('-d', '--duration',
        default='120',
        help='duration of render in frames')

    args = parser.parse_args()
    print (args)
    return args

if __name__=="__main__":

    args = get_args()

    codec = [
        "avformat:%s" % args.output,
        "vcodec=qtrle",
        "mlt_image_format=rgb24a",
        "pix_fmt=argb"
    ]

    prog = [
        "melt",
        "-profile atsc_1080p_60",
        "webvfx:%s" % args.template_name,
        "length=%s" % args.duration
    ] + args.template_args + [
        "transparent=1",
        "-consumer",
    ] + codec + [
        "no_audio=1",
        "frame_rate_num=60",
        "frame_rate_den=1",
        "width=1920",
        "height=1080",
        "transparent=1",
    ]
    print(prog)
    call(prog)
