package Wx::Perl::DirTree::Linux;

use strict;
use warnings;
use Exporter;

our @ISA    = qw(Exporter);
our @EXPORT = qw(
    add_root
    AddChildren
);

our $VERSION = 0.01;

sub add_root {
    my ($self) = @_;
    
    $self->AddRoot( '/' );
    my $root = $self->SetPlData( $root, '/' );
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
        my @array = _get_content( $data );

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
    
    return map{ [ $_, $dir . '/' . $_, -d $dir . '/' . $_ ] }(@files);
}

1;