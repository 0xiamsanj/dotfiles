/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

static int topbar = 1;                      /* -b  option; if 0, dmenu appears at bottom     */
/* -fn option overrides fonts[0]; default X11 font or font set */
static const char *fonts[] = {
	"JetBrainsMonoNL Nerd Font:size=9"
};
static const char *prompt      = NULL;      /* -p  option; prompt to the left of input field */
static const char *colors[SchemeLast][2] = {
	/*     fg         bg       */
	[SchemeNorm] = { "#ffffff", "#000000" },

    // Nord color scheme
	[SchemeSel] = { "#000000", "#a1baf0" },
	[SchemeOut] = { "#a1baf0", "#ebcb8b" },

    // Rosepine color scheme
	[SchemeOut] = { "#d7828e", "#ebcb8b" },
	[SchemeSel] = { "#000000", "#d7828e" },
};
/* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int lines      = 0;

/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";
