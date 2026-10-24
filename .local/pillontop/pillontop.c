/* pillontop — keep Wispr Flow's override-redirect "Status" overlay above
 * other windows.
 *
 * Why: the dictation pill is drawn in an override-redirect X11 window
 * (WM_CLASS "wispr-flow", WM_NAME "Status"). Override-redirect windows are
 * invisible to window managers: dwm can never manage/float/raise it, while
 * dwm does raise normal (floating) windows above it. This daemon watches
 * root stacking changes and re-raises the overlay whenever something ends
 * up above it. The window passes pointer input through (1x1 input shape),
 * so keeping it on top does not block clicks.
 */
#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/Xutil.h>
#include <stdio.h>
#include <string.h>

static Display *dpy;
static Window root;

/* Does the window's name equal "Status"? Checks _NET_WM_NAME and WM_NAME
 * (the property may be STRING or UTF8_STRING, so use XGetTextProperty). */
static int
named_status(Window w)
{
	XTextProperty tp;
	int ok = 0;

	tp.value = NULL;
	if (XGetTextProperty(dpy, w, &tp, XInternAtom(dpy, "_NET_WM_NAME", False))
	    && tp.value && !strcmp((char *)tp.value, "Status"))
		ok = 1;
	if (!ok && tp.value) {
		XFree(tp.value);
		tp.value = NULL;
	}
	if (!ok && XGetTextProperty(dpy, w, &tp, XA_WM_NAME)
	    && tp.value && !strcmp((char *)tp.value, "Status"))
		ok = 1;
	if (tp.value)
		XFree(tp.value);
	return ok;
}

/* The overlay: viewable, override-redirect, class contains "wispr", name "Status". */
static Window
find_overlay(void)
{
	Window w, parent, *kids = NULL, found = None;
	unsigned int n = 0, i;

	if (!XQueryTree(dpy, root, &w, &parent, &kids, &n))
		return None;
	for (i = 0; i < n && found == None; i++) {
		XWindowAttributes wa;
		XClassHint ch;

		if (!XGetWindowAttributes(dpy, kids[i], &wa))
			continue;
		if (wa.map_state != IsViewable || !wa.override_redirect)
			continue;
		ch.res_name = ch.res_class = NULL;
		if (!XGetClassHint(dpy, kids[i], &ch))
			continue;
		if (ch.res_class && strstr(ch.res_class, "wispr") && named_status(kids[i]))
			found = kids[i];
		if (ch.res_name)
			XFree(ch.res_name);
		if (ch.res_class)
			XFree(ch.res_class);
	}
	if (kids)
		XFree(kids);
	return found;
}

/* Last window in XQueryTree order is the topmost sibling of the root. */
static Window
topmost(void)
{
	Window w, parent, *kids = NULL, top = None;
	unsigned int n = 0;

	if (XQueryTree(dpy, root, &w, &parent, &kids, &n) && n)
		top = kids[n - 1];
	if (kids)
		XFree(kids);
	return top;
}

int
main(void)
{
	XEvent ev;
	Window pill;

	if (!(dpy = XOpenDisplay(NULL))) {
		fprintf(stderr, "pillontop: cannot open display\n");
		return 1;
	}
	root = DefaultRootWindow(dpy);
	XSelectInput(dpy, root, SubstructureNotifyMask);
	for (;;) {
		pill = find_overlay();
		if (pill != None && pill != topmost()) {
			XRaiseWindow(dpy, pill);
			XFlush(dpy);
		}
		XNextEvent(dpy, &ev); /* block until any root stacking/map change */
	}
	return 0;
}
