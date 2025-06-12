(function () {
  if ("fonts" in document) {
    // Optimization for Repeat Views
    if (sessionStorage.fontsLoadedSourceFonts) {
      document.documentElement.className += " fonts-loaded-2";
      return;
    }

    Promise.all([
      document.fonts.load("1.5rem 'Source Sans 3 Faux'"),
      document.fonts.load("1.5rem 'Source Code Pro Faux'"),
    ]).then(function () {
      document.documentElement.className += " fonts-loaded-1";

      Promise.all([
        document.fonts.load("1.5rem 'Source Sans 3'"),
        document.fonts.load("italic 1.5rem 'Source Sans 3'"),
        document.fonts.load("1.5rem 'Source Code Pro'"),
        document.fonts.load("italic 1.5rem 'Source Code Pro'"),
      ]).then(function () {
        document.documentElement.className += " fonts-loaded-2";

        // Optimization for Repeat Views
        sessionStorage.fontsLoadedSourceFonts = true;
      });
    });
  }
})();
