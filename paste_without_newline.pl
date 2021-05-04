#!/usr/bin/env perl
use utf8;
use open ':std', ':encoding(UTF-8)';

sub SignReplacer {
    my $arg = shift;
    my %sign_mapper = (','=>'，', '.'=>'。', '!'=>'！', '?'=>'？', ';'=>'；', ':'=>'：', '('=>'（', ')'=>'）');
    return $sign_mapper{$arg};
}

my %fwhw = (
        '０' => '0', '１' => '1', '２' => '2', '３' => '3', '４' => '4',
        '５' => '5', '６' => '6', '７' => '7', '８' => '8', '９' => '9',
        'Ａ' => 'A', 'Ｂ' => 'B', 'Ｃ' => 'C', 'Ｄ' => 'D', 'Ｅ' => 'E',
        'Ｆ' => 'F', 'Ｇ' => 'G', 'Ｈ' => 'H', 'Ｉ' => 'I', 'Ｊ' => 'J',
        'Ｋ' => 'K', 'Ｌ' => 'L', 'Ｍ' => 'M', 'Ｎ' => 'N', 'Ｏ' => 'O',
        'Ｐ' => 'P', 'Ｑ' => 'Q', 'Ｒ' => 'R', 'Ｓ' => 'S', 'Ｔ' => 'T',
        'Ｕ' => 'U', 'Ｖ' => 'V', 'Ｗ' => 'W', 'Ｘ' => 'X', 'Ｙ' => 'Y',
        'Ｚ' => 'Z', 'ａ' => 'a', 'ｂ' => 'b', 'ｃ' => 'c', 'ｄ' => 'd',
        'ｅ' => 'e', 'ｆ' => 'f', 'ｇ' => 'g', 'ｈ' => 'h', 'ｉ' => 'i',
        'ｊ' => 'j', 'ｋ' => 'k', 'ｌ' => 'l', 'ｍ' => 'm', 'ｎ' => 'n',
        'ｏ' => 'o', 'ｐ' => 'p', 'ｑ' => 'q', 'ｒ' => 'r', 'ｓ' => 's',
        'ｔ' => 't', 'ｕ' => 'u', 'ｖ' => 'v', 'ｗ' => 'w', 'ｘ' => 'x',
        'ｙ' => 'y', 'ｚ' => 'z', '－' => '-', '　' => ' ');

sub FullWidthReplacer {
    my $arg = shift;
    return exists($fwhw{$arg}) ? $fwhw{$arg} : $arg
}

my $text = `xclip -selection clipboard -t text/plain -o 2>/dev/null`;
if (!length $text) {
    exit();
}
$text =~ s/(?<=[a-zA-Z])[\r\n]+(?=[a-zA-Z])/ /g;
$text =~ s/[\r\n]//g;
$text =~ s/(?<![a-zA-Z])\s+(?![a-zA-Z])//g;
$text =~ s{(?<![a-zA-Z\s])(\,|\.|\!|\?|;|:|\(|\))}{SignReplacer($1)}eg;
$text =~ s{(.)}{FullWidthReplacer($1)}seg;

system "echo '$text' | xclip -selection clipboard";
system "xdotool key ctrl+v";
