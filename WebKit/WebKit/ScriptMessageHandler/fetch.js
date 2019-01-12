var entries = [];

var tocLinks = document.querySelectorAll('.toc li.toclevel-1 a');

for (var i = 0; i < tocLinks.length; ++i) {
	var tocLink = tocLinks[i];

	var tocText = tocLink.querySelector('.toctext');

	if (!tocText)
		break;

	var entry = { 'title' : tocText.textContent , 'urlString' : tocLink.href };
	entries.push(entry);
}

webkit.messageHandlers.didFetchTableOfContents.postMessage(entries);
