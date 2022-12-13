# Count punctuation marks
# See http://unix.stackexchange.com/q/239894/88378
# Written by PM 2Ring 2015.10.131

BEGIN{
    FS = ""
    punc = ".?!"
    fmt = "%5s: .=%s, ?=%s, !=%s, all=%s\n"
}

/[.?!]+/{
    #print NR, $0, NF
    count[1] = count[2] = count[3] = 0
    for(i=1; i<=NF; i++)
    {
        n = index(punc, $i)
        if(n)
            count[n] += 1
    }
    all = count[1] + count[2] + count[3]
    printf fmt, NR, count[1], count[2], count[3], all
    for(i=1; i<=3; i++)
        total[i] += count[i]
}

END{
    all = total[1] + total[2] + total[3]
    printf fmt, "Total", total[1], total[2], total[3], all
}
