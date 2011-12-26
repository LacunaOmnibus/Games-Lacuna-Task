package Games::Lacuna::Task::Role::PlanetRun;

use 5.010;
use Moose::Role;

has 'exclude_planet' => (
    is              => 'rw',
    isa             => 'ArrayRef[Str]',
    documentation   => 'Do not process given planets',
    traits          => ['Array'],
    default         => sub { [] },
    handles         => {
        'has_exclude_planet' => 'count',
    }
);

has 'only_planet' => (
    is              => 'rw',
    isa             => 'ArrayRef[Str]',
    documentation   => 'Only process given planets',
    traits          => ['Array'],
    default         => sub { [] },
    handles         => {
        'has_only_planet' => 'count',
    }
);

sub run {
    my ($self) = @_;
    
    my @planets;
    
    # Only selected planets
    if ($self->has_only_planet) {
        foreach my $only_planet (@{$self->only_planet}) {
            my $planet = $self->my_body_status($only_planet);
            push(@planets,$planet)
                if $planet;
        }
    # All but selected planets
    } elsif ($self->has_exclude_planet) {
        my @exclude_planets;
        foreach my $planet (@{$self->exclude_planet}) {
            my $planet_id = $self->my_body_id($planet);
            push(@exclude_planets,$planet_id)
                if $planet_id;
        }
        foreach my $planet_stats ($self->my_planets) {
            push(@planets,$planet_stats)
                unless $planet_stats->{id} ~~ \@exclude_planets;
        }
    # All planets
    } else {
        @planets = $self->my_planets;
    }
    
    PLANETS:
    foreach my $planet_stats (@planets) {
        $self->log('info',"Processing planet %s",$planet_stats->{name});
        $self->process_planet($planet_stats);
    }
}

no Moose::Role;
1;

=encoding utf8

=head1 NAME

Games::Lacuna::Role::PlanetRun - Helper role for all planet-centric actions

=cut