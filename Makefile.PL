use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Wx::Perl::DirTree',
    AUTHOR              => 'Renee Baecker <module@renee-baecker.de>',
    VERSION_FROM        => 'lib/Wx/Perl/DirTree.pm',
    ABSTRACT_FROM       => 'lib/Wx/Perl/DirTree.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More'                => 0,
        'Wx::Perl::VirtualTreeCtrl' => 1.017,
        
        ( $^O =~ m!win32! ? 
            ( 'Win32::API'          => 0.46 ) :
            ()
        ),
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Wx::Perl::DirTree-*' },
    ($ExtUtils::MakeMaker::VERSION >= 6.31 ?
      (LICENSE        => 'perl') : ()),
);
