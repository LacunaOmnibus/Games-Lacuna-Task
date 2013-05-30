package Games::Lacuna::Task::Role::Intelligence;

use 5.010;
our $VERSION = $Games::Lacuna::Task::VERSION;
no if $] >= 5.017004, warnings => qw(experimental::smartmatch);

use Moose::Role;

sub assigned_to_type {
    my ($self,$assigned_to) = @_;
    
    return 'own'
        if $assigned_to->{body_id} ~~ [ $self->my_bodies ];
    
    my $body_data = $self->get_body_by_id($assigned_to->{body_id});
    
    return 'unknown'
        unless defined $body_data
        && defined $body_data->{empire};
    
    return $body_data->{empire}{alignment}; 
}

sub assign_spy {
    my ($self,$building,$spy,$assignment) = @_;
    
    return
        unless $spy->{is_available};
    return 
        if $spy->{assignment} eq $assignment;
    return
        if $spy->{name} =~ m/!/; 
    return
        unless grep { $_->{task} eq $assignment } @{$spy->{possible_assignments}};
    
    my $response = $self->request(
        object  => $building,
        method  => 'assign_spy',
        params  => [$spy->{id},$assignment],
    );
    
    $self->log('notice','Assigning spy %s to %s',$spy->{name},$assignment);
    return;
}

no Moose::Role;
1;

=encoding utf8

=head1 NAME

Games::Lacuna::Task::Role::Intelligence - Helper methods for intelligence

=head1 SYNOPSIS

 package Games::Lacuna::Task::Action::MyTask;
 use Moose;
 extends qw(Games::Lacuna::Task::Action);
 with qw(Games::Lacuna::Task::Role::Intelligence);

=head1 DESCRIPTION

This role provides intelligence-related helper methods.

=head1 METHODS

=head2 assigned_to_type

=head2 assign_spy

=cut