#!*perl*

use Test::More tests => 15;
use utf8;

use_ok( 'Games::Lacuna::Task::Utils' );

{
    explain "Parse ship types";
    my %name = (
        'Freighter'     => 'freighter',
        'Colony  Ship'  => 'colony_ship',
        'snark2'        => 'snark2',
        'snark 2'       => 'snark2',
        'Snark_III'     => 'snark3',
        'Snark  IV'     => 'snark4',
        'Supply Pod V'  => 'supply_pod5',
        'Supply_Pod_VI' => 'supply_pod6',
    );
    
    while (my ($name,$expect) = each %name) {
        is(Games::Lacuna::Task::Utils::parse_ship_type($name),$expect,'Ship type ok');
    }
}

{
    explain "Class to/from name";
    is(Games::Lacuna::Task::Utils::name_to_class('trade'),'Games::Lacuna::Task::Action::Trade','Class name ok');
    is(Games::Lacuna::Task::Utils::name_to_class('report incoming'),'Games::Lacuna::Task::Action::ReportIncoming','Class name ok');
    is(Games::Lacuna::Task::Utils::name_to_class('Waste_dispose'),'Games::Lacuna::Task::Action::WasteDispose','Class name ok');
    
    is(Games::Lacuna::Task::Utils::class_to_name('Games::Lacuna::Task::Action::WasteDispose'),'waste_dispose','Name ok');
}


{
    explain "Normalize name";
    is(Games::Lacuna::Task::Utils::normalize_name('Löíz åm Nüñopaß'),'LOIZ AM NUNOPASS','Normalized name ok');
}

{
    explain "Distance";
    is(Games::Lacuna::Task::Utils::distance(0,0,100,100),141.42135623731,'Normalized name ok');
}