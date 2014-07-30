#!/usr/bin/env perl
# Copyright 2014 Michal Špaček <tupinek@gmail.com>

# Pragmas.
use strict;
use warnings;

# Modules.
use Database::DumpTruck;
use English;
use Text::CSV;

# Open a database handle.
my $dt = Database::DumpTruck->new({
	'dbname' => 'data.sqlite',
	'table' => 'data',
});

# Parse __DATA__ section.
my $csv = Text::CSV->new({'binary' => 1});
my $data;
my $num = 0;
while (my $line = <DATA>) {
	if (! $num) {
		$num = 1;
		next;
	}
	$csv->parse($line);
	my @columns = $csv->fields;
	my $col_ar = eval {
		$dt->execute('SELECT Active FROM data WHERE URL = ?', $columns[0]);
	};
	if (! $EVAL_ERROR && @{$col_ar} && exists $col_ar->[0]->{'active'}
		&& defined $col_ar->[0]->{'active'}) {

		# Update active.
		if ($col_ar->[0]->{'active'} != $columns[2]) {
			$dt->execute('UPDATE data SET Active = ? '.
				'WHERE URL = ?', $columns[2], $columns[0]);
		}
	} else {
		$dt->insert({
			'URL' => $columns[0],
			'Title' => $columns[1],
			'Active' => $columns[2],
			'Functionality' => $columns[3],
		});
	}
}

__DATA__
# URL, Title, Active (2 - Unknown, 1 - Active, 0 - Not active), Functionality (2 - Unknown, 1 - Functional, 0 - Failed)
https://classic.scraperwiki.com/scrapers/brno_councillors_retrieval/,Brno Councillors Retrieval,2,2
https://classic.scraperwiki.com/scrapers/subsidized_organizations_of_brno_city_1/,Subsidized organizations of Brno city,2,2
https://classic.scraperwiki.com/scrapers/brno_councillors_downloader/,Brno Councillors Downloader,2,2
https://classic.scraperwiki.com/scrapers/harmonogram_svozu_z_jednotlivych_ulic_-_odpadky_br/,Harmonogram svozu z jednotlivých ulic - odpadky brno,2,2
https://classic.scraperwiki.com/scrapers/brno_councillors_votes_renaming/,Brno Councillors Votes Renaming,2,2
https://classic.scraperwiki.com/scrapers/brno_councillors_minutes/,Brno Councillors Minutes,2,2
https://classic.scraperwiki.com/scrapers/brno_councillors_meetings/,Brno Councillors Meetings,2,2
https://classic.scraperwiki.com/scrapers/average_daily_water_consumption_in_brno_in_liters_/,Average daily water consumption in Brno,0,0
https://classic.scraperwiki.com/scrapers/subsidized_organizations_of_brno_city/,Subsidized organizations of Brno city,2,2
https://classic.scraperwiki.com/scrapers/firebrno/,firebrno,2,2
https://morph.io/soit-sk/brno_average_daily_water_consumption_in_liters,1,1
