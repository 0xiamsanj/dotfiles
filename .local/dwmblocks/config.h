//Modify this file to change what commands output to your statusbar, and recompile using the make command.
//Start/clickable blocks: dwm sends SIGUSR1 (signal<<8 | button) -> dwmblocks re-runs that block with $BLOCK_BUTTON.
static const Block blocks[] = {
	/*Icon*/	/*Command*/			/*Update Interval*/	/*Update Signal*/
	{"",	"~/.local/bin/spotify",		5,	11},
	{"",	"~/.local/bin/wifi",		10,	4},
	{"",	"~/.local/bin/bluetooth",	30,	6},
	{"",	"~/.local/bin/battery",		30,	3},
	{"",	"~/.local/bin/volume",		0,	10},
	{"",	"~/.local/bin/clockdate",	60,	1},
	{"",	"~/.local/bin/clocktime",	30,	2},
};

//Sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char *delim = " | ";
