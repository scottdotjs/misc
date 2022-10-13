#!/usr/bin/perl

use warnings;
use strict;

use WWW::Mechanize;

my $mech = WWW::Mechanize->new();
$mech->agent('Mozilla/5.0 (iPhone; CPU iPhone OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/69.0.3497.105 Mobile/15E148 Safari/605.1');

open (my $OUT, '>', 'years.csv') or die $!;
select $OUT;
$| = 1;

# TODO:
# Output number of items to process
# Do a progress bar thing (find a fancy module for it)

while (<DATA>) {
	$mech->get($_);

	if ($mech->success) {
		my $year = '';
	 	my ($year_found) = $mech->response->decoded_content =~ m{<span itemprop="datePublished">(\d\d\d\d)};

	 	if ($year_found) {
	 		$year = $year_found;
	 	}

	 	chomp(my $url = $_);
	 	print "$url\t$year\n";
	} else {
		print STDERR $mech->response->status_line, "\n";
	}

 	sleep 2;
}

__DATA__
https://archive.org/details/78_stumblin_the-s-m-o-o-t-h-music-of-larry-fotine-cathy-cordovan-zez-confrey_gbia0409848a
https://archive.org/details/78_i-understand_the-four-king-sisters-the-rhythm-reys-kim-gannon-mabel-wayne_gbia0178613b
https://archive.org/details/78_none-legible_gbia0125839b
https://archive.org/details/78_when-its-sunset-time-in-tennessee_tex-slim_gbia0026565a
https://archive.org/details/78_samsons-boogie_lionel-hampton-and-his-hamp-tones-dixon-l-hampton_gbia0044016a
https://archive.org/details/78_bugle-call-rag_metronome-all-star-band-pettis-meyers-schoebel-t.-mondello-b.-carter_gbia0011087a
https://archive.org/details/78_lost-john-boogie_wayne-raney-raney_gbia0202763b
https://archive.org/details/78_slow-freight_bobby-byrne-and-his-orchestra-dorothy-claire-buck-ram-lupin-fien-irvin_gbia0157176a
https://archive.org/details/78_beulhas-boogie_lionel-hampton-and-his-orchestra-lionel-hampton_gbia0018875a
https://archive.org/details/78_the-maid-with-the-flaccid-air_artie-shaw-and-his-orchestra-eddie-sauter_gbia0115479b
https://archive.org/details/78_brushin-off-the-boogie_joe-sullivan-quintette-joe-sullivan-archie-rosate-zutty-sin_gbia0060437b
https://archive.org/details/78_eight-beat-boogie_johnny-maddox-and-the-rhythmasters-pinetop-smith_gbia0011586b
https://archive.org/details/78_night-train_jerry-murads-harmonicats-forrest_gbia0091036b
https://archive.org/details/78_sous-le-ciel-de-paris_marcel-pagnoul-et-son-grand-orchestre-de-valses-viennoises-hu_gbia0381733b
https://archive.org/details/78_i-tin-whistle-at-you_hop-lips-page-and-randy-hall-the-tin-fluters-jeffrey-wasserman_gbia0406439b
https://archive.org/details/78_the-humphrey-bogart-rhumba_betty-garrett-roberts-lee-harold-mooney_gbia0022519a
https://archive.org/details/78_a-pretty-girl-is-like-a-melody_horace-heidt-and-his-brigadiers-larry-cotton-irving_gbia0091421a
https://archive.org/details/78_getting-some-fun-out-of-life_wingy-mannone-and-his-orchestra-wingy-mannone-edgar-le_gbia0091896b
https://archive.org/details/78_jivin-the-vibres_lionel-hampton-and-his-orchestra-lionel-hampton_gbia0264975a
https://archive.org/details/78_aloha-oe-farewell-to-thee_signor-lou-chiha-friscoe-queen-liliuokalani-leedy_gbia0083021b
https://archive.org/details/78_awful-sad_duke-ellington-and-his-orchestra-bubber-miley-arthur-whetzel-tricky-sam-n_gbia0262190b
https://archive.org/details/78_cow-cow-blues_the-ole-tom-cat-of-the-keys-bob-zurke-and-his-delta-rhythm-band-cha_gbia0055927b
https://archive.org/details/78_is-you-is-or-is-you-aint-ma-baby_louis-jordan-and-his-tympany-five-louis-jordan_gbia0005638b
https://archive.org/details/78_rocket-69_todd-rhodes-orchestra-connie-allen-glover-mann_gbia0063200b
https://archive.org/details/78_the-elks-parade_bobby-sherwood-and-his-orchestra-bobby-sherwood_gbia0290493b
https://archive.org/details/78_back-street_rusty-bryant-and-the-carolyn-club-band-chamblee-simpkins_gbia0206666a
https://archive.org/details/78_bambula_rey-davilla-and-his-orchestra-rey-davilla_gbia0261002a
https://archive.org/details/78_very-8-n-boogie_la-veres-chicago-loopers-joe-yukl-billy-may-artie-shapiro-nick-fa_gbia0023088a
https://archive.org/details/78_wabash-cannonball_eddie-mcmullens-sleepy-valley-five-eddie-a-p-carter_gbia0133257b
https://archive.org/details/78_if-i-had-a-talking-picture-of-you_ralph-haines-de-sylva-brown-henderson_gbia0046299a
https://archive.org/details/78_the-trouble-with-me-is-you_johnny-bothwell-and-his-orchestra-handy-segal_gbia0270036a
https://archive.org/details/78_chicken-shuffle_louis-brooks-and-his-hi-toppers-brooks_gbia0053642b
https://archive.org/details/78_the-new-birmingham-breakdown_duke-ellington-and-his-famous-orchestra-duke-ellington_gbia0046314a
https://archive.org/details/78_cant-get-you-off-my-mind_wingy-manone-and-dixieland-orch-wingy-manone-wingy-manon_gbia0268764b
https://archive.org/details/78_these-foolish-things_sheboblou-trio-lou-stein-shelly-manne-bob-carter_gbia0285494b
https://archive.org/details/78_walkin-the-streets-until-my-baby-comes-home_wingy-mannone-and-his-orchestra-wing_gbia0043645a
https://archive.org/details/78_smoke-smoke-smoke-that-cigarette_lawrence-welk-and-his-champagne-music-bob-tex_gbia0193268a
https://archive.org/details/78_popity-pop_slim-gaillard-orchestra-dodo-marmarosa-john-birks-c-parker-jack-mack-ti_gbia0076461b
https://archive.org/details/78_time-and-time-again-para-siempre_wayne-king-his-orchestra-berkeley-graham-carle_gbia0055761b
https://archive.org/details/78_last-night-my-heart-crossed-the-ocean_sally-clark-sundin-kennedy_gbia0089440a
https://archive.org/details/78_when-you-potato-is-done_thibault_gbia0023741a
https://archive.org/details/78_dee-dees-dance_red-norvo-sextet-red-norvo-aaron-sacks-remo-palmieri-danny-negri-cl_gbia0151022b
https://archive.org/details/78_you-are-doin-me-me-wrong_arthur-gunter-gunter_gbia0053641b
https://archive.org/details/78_too-busy_the-four-rajahs-roy-hurt-genty-chicco-and-his-syncopated-harp-ned-miller_gbia0096790a
https://archive.org/details/78_piggy-wiggy-woo_paul-whitemans-four-modernaires-paul-whitemans-swing-wing-abel-ba_gbia0097958a
https://archive.org/details/78_its-the-talk-of-the-town_coleman-hawkins-leo-mathisen-and-his-orchestra-livingston_gbia0005614b
https://archive.org/details/78_blues-and-misery_tulsa-red-tulsa-red-and-his-trio_gbia0060593b
https://archive.org/details/78_mellow-mood_dodo-marmarosa-trio-dodo-marmarosa-ray-brown-jackie-mills-marmarosa_gbia0076696a
https://archive.org/details/78_buttons-and-bows_evelyn-knight-jay-livingston-ray-evans-mannie-klein_gbia0051317a
https://archive.org/details/78_you-turned-my-love-to-hate_the-101-ranch-boys-rusty-harp-edwards-braverman_gbia0222362b
https://archive.org/details/78_song-of-the-islands-cancion-de-las-islas_wayne-king-and-his-orch.-chas.-e.-king_gbia0008037b
https://archive.org/details/78_jeg-sa-julemanden-kysse-mor-i-saw-mommy-kissing-santa-claus_musse-fenger-eriksen_gbia7002259a
https://archive.org/details/78_brazil-aquarela-do-brasil_eddy-duchin-and-his-orchestra-tony-leonard-russell-barr_gbia0180077b
https://archive.org/details/78_lemon-drop_chubby-jackson-and-his-fifth-dimensional-jazz-group-c-jackson-f-socolo_gbia0060377b
https://archive.org/details/78_youve-got-to-be-modernistic_james-p-johnson_gbia0151077b
https://archive.org/details/78_you-go-to-my-head_stan-getz-gillespie-coots_gbia0059942a
https://archive.org/details/78_dont-you-know-i-love-you-baby_gatemouth-moore-moore-larkin_gbia0063108b
https://archive.org/details/78_vibra-tharpe_cal-tjader-trio-cal-tjader-vince-guaraldi-jack-weeks-bramy-valerio-zan_gbia0062312a
https://archive.org/details/78_when-rosie-riccoola-do-the-hoola-ma-boola_jerry-colonna-wesley-tuttle-and-his-texas_gbia0007360b
https://archive.org/details/78_bobbys-blues_soft-lights-and-bobby-hackett-bobby-hackett-sid-feller_gbia0194243b
https://archive.org/details/78_harlem-nocturne_randy-brooks-and-his-orchestra-eddie-caine-earl-hagen_gbia0030866a
https://archive.org/details/78_im-in-love-with-the-honorable-mr-so-and-so_artie-shaw-and-his-orchestra-helen-for_gbia0237444a
https://archive.org/details/78_you-oughta-see-my-fannie-dance_sweet-violet-boys-simons_gbia0079214a
https://archive.org/details/78_such-a-night_bunny-paul-lincoln-chase-sy-oliver_gbia0052886a
https://archive.org/details/78_scatter-brain_ambrose-and-his-orchestra-jack-cooper-keene-bean-burke-masters_gbia0150775b
https://archive.org/details/78_smoke-comes-out-my-chimney_bob-atcher-bob-atcher-v-j-mcalpin_gbia0238197a
https://archive.org/details/78_love-is-fun_the-three-suns-norman-brown-ballard-t-edwards-jr-artie-dunn-and-the_gbia0043863a
https://archive.org/details/78_five-guitars-in-flight_earle-spencer-and-his-orchestra-arv-garrison-quintet-a-garr_gbia0187148a
https://archive.org/details/78_please-help-me_eddie-boyd-and-his-chess-men-boyd_gbia0074439b
https://archive.org/details/78_the-pinball-millionaire_jene-oquin-hank-locklin_gbia0230063b
https://archive.org/details/78_a-santa-barbara_celina-y-reutilio_gbia0021521a
https://archive.org/details/78_its-a-hundred-to-one-im-in-love_johnny-messner-and-his-music-box-band-jeanne-d_gbia0099020a
https://archive.org/details/78_get-your-kicks-from-the-country-hicks_johnny-hicks-his-country-hicks-fields-han_gbia0204173a
https://archive.org/details/78_moon-glow_joe-venuti-and-his-orchestra-will-hudson_gbia0022752a
https://archive.org/details/78_its-the-talk-of-the-town_coleman-hawkins-orchestra-levinson-symes-neiburg-coleman_gbia0004578b
https://archive.org/details/78_my-blue-heaven-mi-cielito-azul_stuff-smith-and-his-orchestra-stuff-smith-whitin_gbia0026855a
https://archive.org/details/78_get-hep_johnny-fosdick-and-orchestra-anita-boyer-kresa-palmer_gbia0072878b
https://archive.org/details/78_stardreams_dick-jurgens-and-his-orch-eddie-howard-freed-jurgens_gbia0026464
https://archive.org/details/78_big-ben-boogie_frank-petty-trio-mike-de-napoli-joe-perella-frank-petty-di-napoli_gbia0115985b
https://archive.org/details/78_a-cowboy-honeymoon_patsy-montana-the-prairie-ramblers-heagney-reed_gbia0005198b
https://archive.org/details/78_lazy-lady-blues_count-basie-and-his-orchestra-jimmy-rushing-feather-p-moore_gbia0030168b
https://archive.org/details/78_clementine-clementina_duke-ellington-and-his-famous-orchestra-billy-strayhorn_gbia0017670a
https://archive.org/details/78_blue-comet-blues_bill-haley-and-his-comets-frank-beecher-al-rex_gbia0293046b
https://archive.org/details/78_crazy-organ-rag_lenny-dee-scott-joplin-dave-woody_gbia0113820b
https://archive.org/details/78_ive-taken-all-im-gonna-take-from-you_spade-cooley-and-his-orch.-tex-williams--f_gbia0007924b
https://archive.org/details/78_music-maestro-please-a-tocar-maestro_tommy-dorsey-and-his-orchestra-herb-magid_gbia0016491a
https://archive.org/details/78_table-top-boogie_deryck-sampson_gbia0063804a
https://archive.org/details/78_oh-gee-say-gee-you-ought-to-see-my-gee-gee_billy-jones-l-brown-a-von-tilzer_gbia0165683a
https://archive.org/details/78_whos-on-first-part-a_abbott-costello_gbia0106735a
https://archive.org/details/78_woo-woo_harry-james-and-the-boog-woogie-trio-james-albert-ammons-johnny-williams-ed_gbia0007768b
https://archive.org/details/78_wob-a-ly-walk-tambaleo_warings-pennsylvanians-harry-warren-buddy-green_gbia0102890a
https://archive.org/details/78_the-mystery-song_duke-ellington-and-his-orchestra-ellington-mills_gbia0265796b
https://archive.org/details/78_ill-hold-you-in-my-heart-till-i-can-hold-you-in-my-arms_rex-turner-and-the-weste_gbia0090143b
https://archive.org/details/78_thats-what_the-king-cole-trio-king-cole-nat-cole_gbia0025709b
https://archive.org/details/78_harlem-camp-meeting_cab-calloway-and-his-cotton-club-orchestra-cab-calloway-and-cho_gbia0160125a
https://archive.org/details/78_oodles-of-noodles_jimmy-dorsey-dorsey-brothers-orchestra-j-dorsey_gbia0023174
https://archive.org/details/78_coctail-piano-no-7_charles-norman-and-his-coctail-piano_gbia0121912a
https://archive.org/details/78_the-secretary-song_ted-weems-and-his-orchestra-shirley-richards-fain-barnett_gbia0012840a
https://archive.org/details/78_that-solid-old-man-is-here-again_larry-clintons-bluebird-orchestra-butch-stone-b_gbia0132827a
https://archive.org/details/78_kukuna-oka-la_dick-mcintires-harmony-hawaiians-lani-mcintire-flores-noble_gbia0013968b
https://archive.org/details/78_i-hate-myself-for-being-so-mean-to-you_todd-rollins-and-his-orchestra-chick-bullo_gbia0158800a
https://archive.org/details/78_mop-mop_leonard-feathers-all-stars-coleman-hawkins-cootie-williams-edmond-hall-art_gbia0022861b
https://archive.org/details/78_mood-indigo_duke-ellington-and-his-famous-orchestra-ellington-bigard-mills_gbia0036377a
https://archive.org/details/78_gaslight_errol-garner-garner_gbia0155450a
https://archive.org/details/78_blues-in-the-night-my-mama-done-tol-me_larry-adler-john-kirby-and-his-orchestra_gbia0182924b
https://archive.org/details/78_oh-moon_the-man-with-the-horn-ray-anthony-and-his-orchestra-petkere_gbia0014421b
https://archive.org/details/78_my-daddy-was-a-lovin-man_harlem-hamfats-hamfoot-ham-morand-mccoy_gbia0048727b
https://archive.org/details/78_dancing-to-the-piano-no-20_semprini_gbia7000905a
https://archive.org/details/78_im-afraid-the-masquerade-is-over_the-moonglows-a-wruvel-h-magidson_gbia0074422b
https://archive.org/details/78_i-wanna-hug-ya-kiss-ya-squeeze-ya_buddy-claudia-buddy-griffin-and-his-orch-gri_gbia0074440b
https://archive.org/details/78_the-nightmare_clyde-mccoy-and-his-orchestra-len-riley-billy-meyers-al-handler_gbia0157254a
https://archive.org/details/78_why-have-a-falling-out-just-when-were-falling-in-love_les-brown-and-his-band-of_gbia0159235b
https://archive.org/details/78_the-world-is-waiting-for-the-sunrise_sammy-benskin-trio-sammy-benskin-billy-taylor_gbia0181897a
https://archive.org/details/78_as-long-as-youre-not-in-love-with-anyone-else-why-dont-you-fall-in-love-with-me_gbia0060122a
https://archive.org/details/78_neals-deal_count-basie-and-his-orchestra-basie-hefti_gbia0064724b
https://archive.org/details/78_panassie-stomp_count-basie-and-his-orchestra-count-basie_gbia0013832b
https://archive.org/details/78_relaxing-at-camarillo_charlie-parker-all-stars-charlie-parker-wardell-gray-howard-m_gbia0039340a
https://archive.org/details/78_til-paris_gustav-winckler-h-m-v-orkester-og-kor-vibeke-flach-poul-nordlander-geo_gbia0125803b
https://archive.org/details/78_abba-dabba-one-of-the-arabian-knights_larry-clinton-and-his-orchestra-i-rusin-s_gbia0213219a
https://archive.org/details/78_parkers-mood_charlie-parker-all-stars-charles-parker-miles-davis-curley-russell-ma_gbia0062068b
https://archive.org/details/78_do-you-know-what-it-means-to-be-lonely_bill-kenny-of-the-ink-spots-al-hoffman-milto_gbia0050778b
https://archive.org/details/78_bed-rock_dicky-wells-big-seven-buck-clayton-dicky-wells-george-treadwell-bud-johns_gbia0039442b
https://archive.org/details/78_dont-take-your-love-from-me_harry-james-and-his-orchestra-lynn-richards-nemo_gbia0018734b
https://archive.org/details/78_if-i-were-you_the-four-vagabonds-buddy-bernier-bob-emmerich_gbia0077901b
https://archive.org/details/78_im-bashful_mindy-carson-al-schofield-bob-merrill-henri-rene_gbia0078321b
https://archive.org/details/78_too-late-for-tears_lloyd-price-and-his-orchestra-h-p-smith_gbia0061181b
https://archive.org/details/78_signal-samba-samba-que-eu_stanley-black-and-his-orchestra-djalma-ferreira_gbia0114698a
https://archive.org/details/78_the-phantom-of-the-rhumba-el-fantasmo-de-la-rumba_enric-madriguera-his-hotel-we_gbia0020691a
https://archive.org/details/78_mamas-gone-goodbye_gay-jones-quintette-bocage-piron_gbia0213738b
https://archive.org/details/78_sophisticated-lady_paul-laval-and-his-woodwindy-ten-of-nbcs-chamber-music-society_gbia0020362
https://archive.org/details/78_shady-green-pastures_georgia-peach-the-harmonaires-john-myers_gbia0073195a
https://archive.org/details/78_give-it-to-me-daddy_jack-ross-and-his-orchestra-jack-ross-don-curry-elmer-isaccs-bo_gbia0154252a
https://archive.org/details/78_if-i-live-to-be-a-hundred_mills-brothers-gil-mills-al-frazzini-billy-faber_gbia0028937a
https://archive.org/details/78_leonas-boogie_duke-henderson-king-perry-orchestra-king-perry-ike-brown-maxie-war_gbia0053622a
https://archive.org/details/78_big-stockings_cedric-wallace-quintet-wallace--smith_gbia0008319b
https://archive.org/details/78_the-touch-le-grisbi_harry-james-his-orch-wiener_gbia0109615a
https://archive.org/details/78_mona-lisa_harry-james-and-his-orchestra-dick-williams-evans-livingston_gbia0123686b
https://archive.org/details/78_arthur-murray-taught-me-dancing-in-a-hurry_the-four-king-sisters-the-rhythm-reys_gbia0024244a
https://archive.org/details/78_i-want-to-be-happy_little-jazz-and-his-trumpet-ensemble-little-jazz-emmett-berr_gbia0009694a
https://archive.org/details/78_you-betcha-my-life_count-basie-and-his-orchestra-earl-warren-j-dennis-m-dennis_gbia0089315a
https://archive.org/details/78_i-wanna-play-house-with-you_eddy-arnold-the-tennessee-plowboy-cy-coben_gbia0079374a
https://archive.org/details/78_limehouse-blues_sidney-bechet-and-his-new-orleans-feetwarmers-sidney-bechet-charlie_gbia0023103b
https://archive.org/details/78_as-you-desire-me_the-twilight-three-allie-wrubel_gbia0068924a
https://archive.org/details/78_baltimore-oriole_hoagy-carmichael-orchestra-hoagy-carmichael-carmichael-webster_gbia0067244e
https://archive.org/details/78_whats-the-use-of-getting-sober-when-you-gonna-get-drunk-again_louis-jordan-and-h_gbia0045916a
https://archive.org/details/78_chicken-in-the-car_ralph-flanagan-and-his-orchestra-steve-benoric-and-the-band-milt_gbia0103985a
https://archive.org/details/78_keep-on-churnin_wynonie-harris-todd-rhodes-orchestra-hairston-glover-mann_gbia0063202b
https://archive.org/details/78_where-the-river-shannon-flows_bunk-johnson_gbia0190954b
https://archive.org/details/78_afternoon-in-paris_sonny-stitt-and-his-band-jay-jay-johnson-sonny-stitt-john-lewis_gbia0072893a
https://archive.org/details/78_big-john-special_benny-goodman-and-his-orch-horace-henderson_gbia0016492b
https://archive.org/details/78_you-gotta-ho-de-ho-to-get-along-with-me_swift-jewel-cowboys-kokomo-corcker-brown_gbia0025130b
https://archive.org/details/78_baby-were-really-in-love_frank-miller-and-his-drifting-texans-frank-miller-willia_gbia0057069b
https://archive.org/details/78_vote-for-mr-boogie_buzz-connie-jessie-mae-robinson_gbia0128285b
https://archive.org/details/78_swingin-down-the-lane_will-bradley-and-his-orchestra-ray-mckinley-gus-kahn-isham-j_gbia0023509a
https://archive.org/details/78_hows-trix_shearing-george-shearing-chuck-wayne-marjorie-hyams-john-o.-levy-jr.-d_gbia0000435b
