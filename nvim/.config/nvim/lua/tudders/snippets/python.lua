local ls = require("luasnip")

-- local s = ls.snippet
-- local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node

local u = require("tudders.snippets.utils")

local snippets = u.make({

	ranged_for = {
		trig = "for",
		desc = "Ranget for loop",
		t({ "for " }),
		i(1, "i"),
		t({ " in range(" }),
		i(0, "n"),
		t({ "):" }),
		t({ "", "\tpass" }),
	},

	mpl_setup = {
		desc = "Things to setup global mpl",
		t({
			"from matplotlib import pyplot as plt",
			"from matplotlib import use as mpl_use",
			"from matplotlib import ticker",
			"",
			"mpl_use('Agg')",
			"plt.rcParams['font.family'] = 'serif'",
		}),
	},

	mpl_slope_lines = { --{{{
		desc = "slope lines plot",
		t({
			"# Data from p158 of Visual Display of Quantitative Information.",
			"labels = [",
			"    'Sweden', 'Netherlands', 'Norway', 'Britain', 'France', 'Germany',",
			"    'Belgium', 'Canada', 'Finland', 'Italy', 'United States', 'Greece',",
			"    'Switzerland', 'Spain', 'Japan'",
			"]",
			"y_left = [46.9, 44, 43.5, 40.7, 39, 37.5, 35.2, 35.2, 34.9, 30.4, 30.3, 26.8, 26.5, 22.5, 20.7]",
			"y_right = [57.4, 55.8, 52.2, 39, 43.4, 42.9, 43.2, 35.8, 38.2, 35.7, 32.5, 30.6, 33.2, 27.1, 26.6]",
			"",
			"# Plot the lines..",
			"fig, ax = plt.subplots(figsize=(3, 15))",
			"for left, right in zip(y_left, y_right):",
			"    ax.plot([0, 1], [left, right], color='black', linewidth=1)",
			"",
			"",
			"def resolve_overlaps(y, lh):",
			"    '''",
			"    Given a sorted list of y values, adjust them so all adjacent values are",
			"    more than lh distance apart.",
			"    '''",
			"    y = np.asarray(y)",
			"    y_new = y.copy()",
			"",
			"    diff = np.abs(y - np.roll(y, -1))",
			"    overlaps_with_next = diff < lh",
			"    if not(any(overlaps_with_next)):",
			"        return y",
			"",
			"    id_ = 0",
			"    bunch_ids = np.nan * y",
			"    for i in range(1, len(y)):",
			"        if overlaps_with_next[i]:",
			"            bunch_ids[i] = id_",
			"        elif overlaps_with_next[i - 1] and not overlaps_with_next[i]:",
			"            bunch_ids[i] = id_",
			"            id_ += 1",
			"    if overlaps_with_next[0]:",
			"        bunch_ids[0] = bunch_ids[1]",
			"",
			"    for id_ in np.unique(bunch_ids[np.isfinite(bunch_ids)]):",
			"        bunch = y[bunch_ids == id_]",
			"        bunch_new = bunch.copy()",
			"        n = len(bunch)",
			"        centre = bunch.min() + (bunch.max() - bunch.min()) / 2",
			"        bunch_new = np.linspace(centre - (lh * (n - 1) / 2), centre + (lh * (n - 1) / 2), n)",
			"        y_new[bunch_ids == id_] = bunch_new",
			"",
			"    return y_new",
			"",
			"",
			"# Draw left label and value. Need to sort labels first, then adjust for overlaps.",
			"line_height = 1",
			"y_left_sorted, labels_sorted = zip(*sorted(zip(y_left, labels)))",
			"y_left_plot = resolve_overlaps(y_left_sorted, line_height)",
			"for y, y_text, label in zip(y_left_sorted, y_left_plot, labels_sorted):",
			"    ax.text(-0.2, y_text, '{:.1f}'.format(y), va='center')",
			"    ax.text(-0.3, y_text, label, ha='right', va='center')",
			"",
			"# Same for the right labels.",
			"y_right_sorted, labels_sorted = zip(*sorted(zip(y_right, labels)))",
			"y_right_plot = resolve_overlaps(y_right_sorted, line_height)",
			"for y, y_text, label in zip(y_right_sorted, y_right_plot, labels_sorted):",
			"    ax.text(1.1, y_text, '{:.1f}'.format(y), va='center')",
			"    ax.text(1.3, y_text, label, va='center')",
			"",
			"# Remove axis lines.",
			"ax.axis('off')",
			"",
			"# Annotations.",
			"title = 'Current Receipts of Government as a'",
			"title += '\\nPercentage of Gross Domestic'",
			"title += '\\nProduct, 1970 and 1979'",
			"ax.text(-2, 56.1, title, size=11)",
			"ax.text(-0.2, 60, '1970', size=11)",
			"ax.text(1.1, 60, '1979', size=11)",
			"",
		}),
	}, --}}}

	mpl_fig = { --{{{
		desc = "matplot lib plot",
		t({
			"fig = plt.figure(figsize=(7, 7 * 1.618))",
			"ax = fig.add_subplot(111)",
			"",
			"ax.set_xlabel('')",
			"ax.set_ylabel('')",
			"",
			"# Remove axis spines",
			"ax.spines['top'].set_visible(False)",
			"ax.spines['right'].set_visible(False)",
			"",
			"# Set spine extent",
			"ax.spines['bottom'].set_bounds(min(x), max(x))",
			"ax.spines['left'].set_bounds(min(y), max(y))",
			"",
			"# Reduce tick spacing",
			"# x_ticks = list(range(min(x), max(x) + 1, 5))",
			"# ax.xaxis.set_ticks(x_ticks)",
			"ax.xaxis.set_major_locator(ticker.MultipleLocator(base=2))",
			"ax.yaxis.set_major_locator(ticker.MultipleLocator(base=2))",
			"ax.tick_params(direction='in')",
			"",
			"# Adjust lower limits to let data breathe",
			"ax.set_xlim([0, ax.get_xlim()[1]])",
			"ax.set_ylim([0, ax.get_ylim()[1]])",
			"",
			"fig.savefig('fig.png', bbox_inches='tight')",
			"plt.close(fig)",
		}),
	}, --}}}

	mpl_bar = { --{{{
		desc = "bar graph",
		t({
			"ax.bar(x, y, color='#7a7a7a', width=0.6)",
			"",
			"# Remove axis lines.",
			"ax.spines['top'].set_visible(False)",
			"ax.spines['right'].set_visible(False)",
			"ax.spines['bottom'].set_visible(False)",
			"ax.spines['left'].set_visible(False)",
			"",
			"# Add labels to x axis.",
			"ax.set_xticks(x)",
			"ax.set_xticklabels(labels)",
			"",
			"# Add labels to y axis.",
			"y_ticks = [...]",
			"ax.set_yticks(y_ticks)",
			"ax.set_yticklabels(y_ticks)",
			"ax.yaxis.set_major_formatter(ticker.MultipleLocator(base=2))",
			"",
			"# Remove tick marks.",
			"ax.tick_params(bottom=False, left=False)",
			"",
			"# Add bar lines as a horizontal grid.",
			"ax.yaxis.grid(color='white')",
		}),
	}, --}}}

	mpl_percent_ticker = {
		desc = "matplotlib percent axis ticks",
		t({ "ax.yaxis.set_major_formatter(ticker.PercentFormatter(xmax=1, decimals=0))" }),
	},

	mpl_scatter = {
		desc = "Tufte style dotted line",
		t({ "ax.scatter(x, y, color='black', s=20)" }),
	},

	mpl_dotted_line = {
		desc = "Tufte style dotted line",
		t({
			"ax.plot(x, y, linestyle='-', color='black', linewidth=1, zorder=1)",
			"ax.scatter(x, y, color='white', s=100, zorder=2)",
			"ax.scatter(x, y, color='black', s=20, zorder=3)",
		}),
	},

	mpl_hline = {
		desc = "axis hline",
		t({ "ax.axhline(y_val, ls='-', lw=0.5, alpha=0.5, color='k')" }),
	},

	mpl_vline = {
		desc = "axis vline",
		t({ "ax.axvline(x_val, ls='-', lw=0.5, alpha=0.5, color='k')" }),
	},

	mpl_text = {
		desc = "text annotation",
		t({ "ax.text(x_pos, y_pos, 'Text', color='k')" }),
	},
})

local autosnippets = {

	-- s({trig= "...", desc="dots", wordTrig=false} , t{"\\dots "}),
}

return {
	snippets = snippets,
	autosnippets = autosnippets,
}
