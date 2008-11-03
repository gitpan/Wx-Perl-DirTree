package Wx::Perl::DirTree;

use strict;
use warnings;


use Wx qw(wxOK wxID_ABOUT wxID_EXIT wxICON_INFORMATION wxTOP wxVERTICAL wxNO_FULL_REPAINT_ON_RESIZE wxSYSTEM_MENU wxCAPTION wxMINIMIZE_BOX wxCLOSE_BOX wxDefaultPosition);
use Wx::Event qw(EVT_MENU EVT_CLOSE EVT_SIZE EVT_UPDATE_UI EVT_KEY_DOWN);
use Wx::Perl::VirtualTreeCtrl qw(EVT_POPULATE_TREE_ITEM);

our $VERSION = 0.02;


sub new {
    my ($class,$parent,$size) = @_;
    
    my $self = bless {}, $class;
    
    _load_subs();
    $self->tree( $parent, $size );
    
    return $self;
}

sub tree {
    my ($self, $parent, $size) = @_;
    
    if( !$self->{tree} and $parent and $size ){
        $self->{treectrl} = Wx::TreeCtrl->new( 
            $parent, -1, wxDefaultPosition, $size 
        );
        
        $self->{tree}     = Wx::Perl::VirtualTreeCtrl->new( 
            $self->{treectrl}, -1, wxDefaultPosition, $size 
        );
    
        EVT_POPULATE_TREE_ITEM( $parent, $self->{tree}, \&AddChildren );
        
        add_root( $self->{tree} );
    }
    
    return $self->{tree};
}

sub GetTree {
    my ($self) = @_;
    
    return $self->tree->GetTree;
}

sub GetSelectedPath {
    my ($self) = @_;
    
    my $tree = $self->tree;
    my $path = $tree->GetPlData( $tree->GetSelection );
    return $path;
}

sub _load_subs {
    my $os = $^O;
    
    if( $os =~ /win32/i ){
        require Wx::Perl::DirTree::Win32;
        Wx::Perl::DirTree::Win32->import();
    }
    else{
        require Wx::Perl::DirTree::Linux;
        Wx::Perl::DirTree::Linux->import();
    }

}

1;

__END__

=pod

=head1 NAME

Wx::Perl::DirTree - A directory tree widget for wxPerl

=head1 DESCRIPTION

Many widgets that display directory trees are dialogs or can't handle drives on
Windows. This module aims to fill the gap. It can be integrated in any frame or
dialog and it handles drives under Windows.

=head1 SYNOPSIS

  use Wx::Perl::DirTree;
  
  my $panel = Wx::Panel->new;
  my $tree  = Wx::Perl::DirTree->new( $panel, [100,100] );
    
  my $main_sizer   = Wx::BoxSizer->new( wxVERTICAL );
  $main_sizer->Add( $tree->GetTree,  0, wxTOP, 0 );
  
  # in a subroutine
  print $tree->GetSelectedPath;

=head1 AUTHOR

Renee Baecker, C<< <module at renee-baecker.de> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-wx-perl-podeditor at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Wx::Perl::PodEditor>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Wx::Perl::PodEditor

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Wx-Perl-PodEditor>

=item * CPAN Ratings

L<http://cpanratings.perl.org/dist/Wx-Perl-DirTree>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Wx-Perl-DirTree>

=item * Search CPAN

L<http://search.cpan.org/dist/Wx-Perl-DirTree>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2008 Renee Baecker, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
