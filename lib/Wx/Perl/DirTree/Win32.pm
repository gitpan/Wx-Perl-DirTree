package Wx::Perl::DirTree::Win32;

use strict;
use warnings;
use Exporter;
#use File::Spec;
use Win32::API;

our @ISA    = qw(Exporter);
our @EXPORT = qw(
    add_root
    AddChildren
);

our $VERSION = 0.01;

sub add_root {
    my ($self) = @_;
    
    my $root = $self->AddRoot( 'Arbeitsplatz' );
    $self->SetPlData( $root, '/' );
    $self->SetItemHasChildren( $root, 1 );
    $self->Expand( $root );
}

sub AddChildren {
    my ($self,$event) = @_;
    
    my $tree = $event->GetEventObject;
    my $item = $event->GetItem;
    my $data = $tree->GetPlData( $item );
    
    if( $tree->GetChildrenCount( $item, 0 ) ){
        warn $data;
        
    }
    else{
        my @array;
        
        if( $data and $data eq '/' ){
            @array = _get_drives();
        }
        else{
            @array = _get_content( $data );
        }

        for my $child ( @array ){
            my ($label,$value,$is_dir) = @$child;
            my $childobj = $tree->AppendItem( $item, $label );
            $tree->SetPlData( $childobj, $value );
            $tree->SetItemHasChildren( $childobj, 1 ) if $is_dir;
        }
    }
}

sub _get_content {
    my ($dir) = @_;
    
    opendir my $dirh, $dir or die $!;
    my @files = sort grep{ !/^\.\.?$/ }readdir $dirh;
    closedir $dirh;
    
    my @list;
    
    for my $file ( @files ){
        my $is_dir = -d $dir . '/' . $file;
        my $value  =  $is_dir ?
                        File::Spec->catdir( $dir, $file )  :
                        File::Spec->catfile( $dir, $file ) ;
        push @list, [ $file, $value, $is_dir ];
    }
    return @list;
}

sub _get_drives {
    my $function = Win32::API->new( 'kernel32', 'GetLogicalDriveStringsA', 'NP', 'N' );
    
    my $drivestr = ' 'x1024;
    my $ret      = $function->Call( 1024, $drivestr );
    
    my $drives   = substr( $drivestr, 0, $ret );
    my @list     = split /\0/, $drives;
    
    @list = map{ [ $_, $_, 1 ] }@list;
    
    return @list;
}

1;