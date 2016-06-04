#
# This package parse the OGMP qualifier file.
#
# You can look up classes associated with the qualifier $qual by
# accessing $main'OGMP_QUALS_CLASSES{$qual}.
#
# You can look up the textual description associated with the
# qualifier $qual by accessing $main'OGMP_QUALS_TEXTS{$qual}.
#
#

package OGMP_Qualifs;

# Files
my $HOME          = $ENV{"HOME"};
my @LIB_PATH      = (($HOME || "."));
push(@LIB_PATH,split(/:/,$ENV{"MF2SQN_LIB"})) if $ENV{"MF2SQN_LIB"};

my $QUALIF_FILE       = "";
foreach my $dir (@LIB_PATH) {
     next if !(-e "$dir/ogmp_qualifiers.lst");
     $QUALIF_FILE    = "$dir/ogmp_qualifiers.lst" if !$QUALIF_FILE    && (-e "$dir/ogmp_qualifiers.lst");
     last if $QUALIF_FILE;
}
 
die "Doesn't find the 'ogmp qualifiers' file 'ogmp_qualifiers.lst'. Check your installation for this one.\n"
     if !$QUALIF_FILE;

open(FH,"<$QUALIF_FILE") ||
    die "Package Gene_Name: Can't read file \"$QUALIF_FILE\": $!\n";
@FILE=<FH>;
close(FH);

@FILE=grep(!/^\s*#|^\s*$/,@FILE);

foreach $line (@FILE) {
    $n=$line;
    my @fields = split(/\|\s+/,$line);
    foreach my $field (@fields){
            $field =~ s/^\s+//;
            $field =~ s/\s+$//;
    }
    my ($qualifier,$classes,$text,$usage,$name) = ($fields[0],$fields[1],$fields[2]);
    die "Package OGMP_Qualifs: can't parse line:\n$line" unless $qualifier;
    $OGMP_QUALS_CLASSES->{$qualifier}=$classes;
    $OGMP_QUALS_TEXTS->{$qualifier}=$text if $text;
    $main'OGMP_QUALS_CLASSES{$qualifier}=$classes;
    $main'OGMP_QUALS_TEXTS{$qualifier}=$text if $text;
    }

# ParseQualifiers
#
# $ident is a string used to identify the line. Used ony when printing
# error message. Ex: 'G-sig-telom_1' or anything else visually helpful.
#
# $rest is the string to parse. It must be a list of legal OGMP qualifiers
# for masterfiles. Ex: '/telomere /rpt_unit="coucou"'
#
# $qual is a reference to an empty hash table that will be filled with
# the parsed qualifier values. So, before calling the routine, initialize
#     $myhash=+{}
# then call
#     &ParseQualifiers("G-sig-telom_1",'/telomere /rpt_unit="coucou"',$myhash);
# and you will get in %$myhash:
#     "telomere" => "SET",
#     "rpt_unit" => "coucou"
#
# Special cases:
#    - /ymf23 is interpreted as /ymf=23
#
# Returns: empty string if everything is ok.
#          Error messages otherwise.
#
sub main'ParseQualifiers {
    local($ident,$rest,$qual) = @_;
    local($qualname,$cont,$value,$ret);    
    
    %$qual=();
    $ret="";
    for (;;) {
        $rest =~ s/^\s*//;
        $rest =~ s/\s*$//;
        last if $rest eq "" || $rest =~ /^;/;
        ($qualname,$value) = ($rest =~ m#^/([\w\-\'\+]+)\s*(=?)#);
        $cont=$';
        return "Can't parse qualifiers at \"$rest\" (Ident=$ident).\n"
            if !defined($qualname) || $qualname eq "";
        if ($value) {
            if ($cont =~ /^\s*"/) {
                ($value) = ($cont =~ /^\s*"([^"]+)"/);
                $cont=$';
                }
            else {
                ($value) = ($cont =~ /^\s*(\S+)/);
                $cont=$';
                }
            return "ParseQualifiers: no value for \"$qualname=\" (Ident=$ident).\n"
                unless defined($value);
            }
        $rest=$cont;
        
        if ($value eq "" && $qualname =~ /^ymf(\d+)(_\w)*$/)
        {
            $add = "" if !defined($2);
            ($qualname,$value) = ( "ymf", $1.$add );
        }
        
        unless ($main'OGMP_QUALS_CLASSES{$qualname}) {
           $ret .= "Error: qualifier \"$qualname\" not known" . ($value ne "" ? " (value=\"$value\") (Ident=$ident)\n" : " (Ident=$ident)\n");
           next;
           }
        $value="SET" if $value eq "";
        $$qual{$qualname}=$value;
        }
    if ($rest) {
        $rest =~ s/;;.*//;
        $rest =~ s/^;\s*//;
        $rest =~ s/\s*$//;
        if ($rest ne "") {
            $$qual{"note"} = "" unless defined($$qual{"note"});
            $$qual{"note"} = &main'ConcatWithSpace($$qual{"note"},$rest,";  ") if $rest;
            }
        }
    $ret;
    }

sub main'ConcatWithSpace {
    local($string1,$string2,$sep) = @_;
    return $string1 if $string2 eq "";
    return $string2 if $string1 eq "";
    $sep=" " unless $sep;
    "$string1$sep$string2";
    }

1;
