#!/usr/bin/env perl
use v5.20;
use utf8;
use open qw(:std :utf8);
use Unicode::UCD qw(charinfo charscript);
use Unicode::Unihan;
use List::Util qw(sum);

#use List::MoreUtils qw(all);

my $uh = Unicode::Unihan->new;
my ( $characters, %freq, $wc, $radical_freq );

while (<>) {
    my @lineChars = split //;
    foreach my $linechar (@lineChars) {
        if ( $linechar =~ /\w/ ) {
            $wc++;
            $freq{"$linechar"}++;
            $characters->{$linechar}->{'freq'}++;
        }
    }
}

# kangxi radicals from https://en.wikipedia.org/wiki/Kangxi_radical
# for decoding to characters from the radical numbers as stored in Unihan
my %kangxi_rad_char = (
    1   => "一",
    2   => "丨",
    3   => "丶",
    4   => "丿",
    5   => "乙",
    6   => "亅",
    7   => "二",
    8   => "亠",
    9   => "人",
    10  => "儿",
    11  => "入",
    12  => "八",
    13  => "冂",
    14  => "冖",
    15  => "冫",
    16  => "几",
    17  => "凵",
    18  => "刀",
    19  => "力",
    20  => "勹",
    21  => "匕",
    22  => "匚",
    23  => "匸",
    24  => "十",
    25  => "卜",
    26  => "卩",
    27  => "厂",
    28  => "厶",
    29  => "又",
    30  => "口",
    31  => "囗",
    32  => "土",
    33  => "士",
    34  => "夂",
    35  => "夊",
    36  => "夕",
    37  => "大",
    38  => "女",
    39  => "子",
    40  => "宀",
    41  => "寸",
    42  => "小",
    43  => "尢",
    44  => "尸",
    45  => "屮",
    46  => "山",
    47  => "巛",
    48  => "工",
    49  => "己",
    50  => "巾",
    51  => "干",
    52  => "幺",
    53  => "广",
    54  => "廴",
    55  => "廾",
    56  => "弋",
    57  => "弓",
    58  => "彐",
    59  => "彡",
    60  => "彳",
    61  => "心",
    62  => "戈",
    63  => "戶",
    64  => "手",
    65  => "支",
    66  => "攴",
    67  => "文",
    68  => "斗",
    69  => "斤",
    70  => "方",
    71  => "无",
    72  => "日",
    73  => "曰",
    74  => "月",
    75  => "木",
    76  => "欠",
    77  => "止",
    78  => "歹",
    79  => "殳",
    80  => "毋",
    81  => "比",
    82  => "毛",
    83  => "氏",
    84  => "气",
    85  => "水",
    86  => "火",
    87  => "爪",
    88  => "父",
    89  => "爻",
    90  => "爿",
    91  => "片",
    92  => "牙",
    93  => "牛",
    94  => "犬",
    95  => "玄",
    96  => "玉",
    97  => "瓜",
    98  => "瓦",
    99  => "甘",
    100 => "生",
    101 => "用",
    102 => "田",
    103 => "疋",
    104 => "疒",
    105 => "癶",
    106 => "白",
    107 => "皮",
    108 => "皿",
    109 => "目",
    110 => "矛",
    111 => "矢",
    112 => "石",
    113 => "示",
    114 => "禸",
    115 => "禾",
    116 => "穴",
    117 => "立",
    118 => "竹",
    119 => "米",
    120 => "糸",
    121 => "缶",
    122 => "网",
    123 => "羊",
    124 => "羽",
    125 => "老",
    126 => "而",
    127 => "耒",
    128 => "耳",
    129 => "聿",
    130 => "肉",
    131 => "臣",
    132 => "自",
    133 => "至",
    134 => "臼",
    135 => "舌",
    136 => "舛",
    137 => "舟",
    138 => "艮",
    139 => "色",
    140 => "艸",
    141 => "虍",
    142 => "虫",
    143 => "血",
    144 => "行",
    145 => "衣",
    146 => "襾",
    147 => "見",
    148 => "角",
    149 => "言",
    150 => "谷",
    151 => "豆",
    152 => "豕",
    153 => "豸",
    154 => "貝",
    155 => "赤",
    156 => "走",
    157 => "足",
    158 => "身",
    159 => "車",
    160 => "辛",
    161 => "辰",
    162 => "辵",
    163 => "邑",
    164 => "酉",
    165 => "釆",
    166 => "里",
    167 => "金",
    168 => "長",
    169 => "門",
    170 => "阜",
    171 => "隶",
    172 => "隹",
    173 => "雨",
    174 => "靑",
    175 => "非",
    176 => "面",
    177 => "革",
    178 => "韋",
    179 => "韭",
    180 => "音",
    181 => "頁",
    182 => "風",
    183 => "飛",
    184 => "食",
    185 => "首",
    186 => "香",
    187 => "馬",
    188 => "骨",
    189 => "高",
    190 => "髟",
    191 => "鬥",
    192 => "鬯",
    193 => "鬲",
    194 => "鬼",
    195 => "魚",
    196 => "鳥",
    197 => "鹵",
    198 => "鹿",
    199 => "麥",
    200 => "麻",
    201 => "黃",
    202 => "黍",
    203 => "黑",
    204 => "黹",
    205 => "黽",
    206 => "鼎",
    207 => "鼓",
    208 => "鼠",
    209 => "鼻",
    210 => "齊",
    211 => "齒",
    212 => "龍",
    213 => "龜",
    214 => "龠",
);

# fill the database
my ( %radical_freqs, %pronounciation_nr_freqs );    # additional indices
foreach my $textchar ( keys %$characters ) {

    # total strokes in the character
    $characters->{$textchar}->{'strokes'} = $uh->TotalStrokes("$textchar");

    # sum of all strokes of all the occurrences of this character
    $characters->{$textchar}->{'sum_strokes'} =
      $characters->{$textchar}->{'strokes'} *
      $characters->{$textchar}->{'freq'};

    # Kangxi radical number + extra strokes
    my $kangxi_rad_num = $uh->RSKangXi("$textchar");
    $kangxi_rad_num =~ s/\.(\d+)//;
    my $strokes_after_kangxi_radical = 0;
    $strokes_after_kangxi_radical = $1;
    $characters->{$textchar}->{'radical-kangxi'} = $kangxi_rad_num;
    $radical_freqs{"$kangxi_rad_num"}++;    #radical freq. index
    $characters->{$textchar}->{'radical-kangxi-plus'} =
      $strokes_after_kangxi_radical;

    # Unicode radical + extra strokes
    # For some characters, Unicode has more options of radical + strokes
    my $uni_rad = $uh->RSUnicode("$textchar");
    $uni_rad =~ s/\.(\d+)//;
    my $strokes_after_uni_radical = $1;
    $characters->{$textchar}->{'radical-uni-plus'} = $strokes_after_uni_radical;
    $characters->{$textchar}->{'radical-uni'}      = $uni_rad;

    # Number of pronounciations
    my $prons = $uh->Mandarin("$textchar");

    # write out pronounciations
    # $characters->{$textchar}->{'prons'} =$prons;
    
    # just a nr. of readings
    my @prons = split / /, $prons;
    $characters->{$textchar}->{'prons'} =
      scalar @prons;    
}

# count average strokes
my $sum_strokes_tokens =
  sum map { $characters->{$_}->{'sum_strokes'} } sort keys %$characters;
my $sum_strokes_types =
  sum map { $characters->{$_}->{'strokes'} } sort keys %$characters;
my $types              = scalar keys %$characters;
my $tokens             = $wc;
my $aver_strokes_token = $sum_strokes_tokens / $tokens;
my $aver_strokes_type  = $sum_strokes_types / $types;

# output table of statistics per character
my ( @sorted_types, @sorted_tokens );
@sorted_types = sort { $freq{$b} <=> $freq{$a} } keys %freq; # sort by frequency

# Table header
#say "Character attributes, sorted by character frequency";
say
  "Character\t",
  "Radical\t",
  "Rad. nr.\t",
  "Plus strokes\t",
  "Total strokes\t",
  "Rank\t",
  "Freq. abs.\t",
  "Freq. Rel.\t",
  "Pronounc. nr.";

# compute (frequency) rank
my $rank_f            = 1;
my $freqency_for_rank = $characters->{ $sorted_types[0] }->{'freq'};
foreach my $type (@sorted_types) {
    if ( $characters->{$type}->{'freq'} != $freqency_for_rank ) {
        $freqency_for_rank = $characters->{$type}->{'freq'};
        $rank_f++;
    }

    # print the table lines
    say "$type", "\t",
      $kangxi_rad_char{ $characters->{$type}->{'radical-kangxi'} }, "\t",
      $characters->{$type}->{'radical-kangxi'},      "\t",
      $characters->{$type}->{'radical-kangxi-plus'}, "\t",
      $characters->{$type}->{'strokes'},             "\t",
      $rank_f, "\t",
      $characters->{$type}->{'freq'}, "\t",
      sprintf( "%.4f", $characters->{$type}->{'freq'} / $wc ), "\t",
      $characters->{$type}->{'prons'};

    # not output, just using the cycle to prepare @sorted_tokens and
    # $radical_freq
    push @sorted_tokens, split //, "$type" x $characters->{$type}->{'freq'};
    $radical_freq->{ $characters->{$type}->{'radical-kangxi'} }->{'token'} +=
      $characters->{$type}->{'freq'};
    $radical_freq->{ $characters->{$type}->{'radical-kangxi'} }->{'type'}++;
}

# radical frequency tables
# Unicode block Kangxi Radicals U+2F00 – U+2FD5

# table of radical frequencies by type

# header
say "\n\nRadical frequency per type";

# Radical   Radical nr. Rank    Freq. abs.  Freq. rel.
say "rad\trad. nr.\trank\tf abs.\tf rel.";

# content
my @sorted_rads =
  sort { $radical_freq->{$b}->{'type'} <=> $radical_freq->{$a}->{'type'} }
  keys %{$radical_freq};
my $rank_rt          = 1;    # rank by radical frequency by types
my $freq_for_rank_rt = $radical_freq->{ $sorted_rads[0] }->{'type'};
for my $rad_n (@sorted_rads) {
    if ( $radical_freq->{$rad_n}->{'type'} != $freq_for_rank_rt ) {
        $freq_for_rank_rt = $radical_freq->{$rad_n}->{'type'};
        $rank_rt++;
    }

    # print content lines
    say $kangxi_rad_char{$rad_n}, "\t",
      $rad_n,   "\t",
      $rank_rt, "\t",
      $radical_freq->{$rad_n}->{'type'}, "\t",
      sprintf( "%.4f", $radical_freq->{$rad_n}->{'type'} / $types );
}

# table of radical frequencies by token

# header
say
"\n\nRadical frequency per token (occurrences of radicals in occurrences of characters)";

# Radical   Radical nr. Rank    Freq. abs.  Freq. rel.
say "rad\trad. nr.\trank\tf abs.\tf rel.";

# content
my @sorted_rads_tok =
  sort { $radical_freq->{$b}->{'token'} <=> $radical_freq->{$a}->{'token'} }
  keys %{$radical_freq};
my $rank_rtt         = 1;    # rank by radical frequency by types
my $freq_for_rank_rt = $radical_freq->{ $sorted_rads_tok[0] }->{'token'};
for my $rad_n (@sorted_rads_tok) {
    if ( $radical_freq->{$rad_n}->{'token'} != $freq_for_rank_rt ) {
        $freq_for_rank_rt = $radical_freq->{$rad_n}->{'token'};
        $rank_rtt++;
    }

    # print content lines
    say $kangxi_rad_char{$rad_n}, "\t",
      $rad_n,    "\t",
      $rank_rtt, "\t",
      $radical_freq->{$rad_n}->{'token'}, "\t",
      sprintf( "%.4f", $radical_freq->{$rad_n}->{'token'} / $types );
}

# output table of overall stats
say "\n";
say "Tokens\tTypes\tRatio\tNote";    #\tNote"; #table header
say $tokens, "\t", $types, "\t", sprintf( "%.2f", $tokens / $types ),
  "\tType / Token ratio";
say sprintf( "%.2f", $aver_strokes_token ), "\t",
  sprintf( "%.2f", $aver_strokes_type ), "\t", "\t", "Average Strokes";

# median strokes
my ( $tok_array_ref, $typ_array_ref ) = lists_by_attr('strokes');
my @types_by_strokes  = @{$typ_array_ref};
my @tokens_by_strokes = @{$tok_array_ref};
say median( \@tokens_by_strokes, "strokes" ), "\t",
  median( \@types_by_strokes, "strokes" ), "\t", "\t", "Median Strokes";

# radicals
say scalar(%radical_freqs), "\t", scalar(%radical_freqs), "\t\t",
  "Number of radicals";

# count nr. of pronounciations
# TODO

######## FUNCTIONS #############

# sorted lists by any attribute (tokens and types)
sub lists_by_attr {
    my $attr = shift;

    my ( @types_by_attr, @tokens_by_attr );
    my %ch_attr = map { $_, $characters->{$_}->{"$attr"} } keys %{$characters};
    @types_by_attr = sort { $ch_attr{$b} <=> $ch_attr{$a} } keys %ch_attr;

    #	say join ", ", @types_by_attr;
    foreach my $type (@types_by_attr) {
        push @tokens_by_attr, split //,
          "$type" x $characters->{$type}->{'freq'};
    }

    #	say "\n\n", join ", ", @tokens_by_attr;
    return \@tokens_by_attr, \@types_by_attr;    # FIX THIS!
}

# median
sub median {
    my $list_for_median = shift;
    my $attr_name       = shift;
    my $median;
    my $middle = scalar @{$list_for_median} / 2;

 # even number of text types (characters) For instance:
 # (4,3,2,1) scalar = 4, $middle = 2, $sorted_types[$middle] is the 3rd element,
 # i.e. the one ABOVE the median, so we need also the one below and average
 # the freq. values
    if ( int($middle) == $middle )
    {    # even number, so median is between 2 values
        my $below = $middle - 1;
        my $below_char_freq =
          $characters->{ $list_for_median->[ int($below) ] }->{"$attr_name"};
        my $above_char_freq =
          $characters->{ $list_for_median->[ int($middle) ] }->{"$attr_name"};
        $median = ( $below_char_freq + $above_char_freq ) / 2;
    }
    else {
        $median =
          $characters->{ $list_for_median->[ int($middle) ] }->{"$attr_name"};
    }
    return $median;
}
