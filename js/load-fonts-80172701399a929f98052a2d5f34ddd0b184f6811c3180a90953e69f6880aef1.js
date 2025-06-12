(function () {
  if ("fonts" in document) {
    if (sessionStorage.fontsLoadedSourceFonts) {
      document.documentElement.className += " fonts-loaded-2";
      return;
    }

    const stage1Promises = [
      "1.5rem 'Source Sans 3 Faux'",
      "1.5rem 'Source Code Pro Faux'",
    ];
    const stage2Promises = [
      "1.5rem 'Source Sans 3'",
      "1.5rem 'Source Code Pro'",
      "italic 1.5rem 'Source Sans 3'",
      "italic 1.5rem 'Source Code Pro'",
    ];

    Promise.all(stage1Promises.map((font) => document.fonts.load(font))).then(
      function () {
        document.documentElement.className += " fonts-loaded-1";

        Promise.all(
          stage2Promises.map((font) => document.fonts.load(font)),
        ).then(function () {
          document.documentElement.className += " fonts-loaded-2";
          sessionStorage.fontsLoadedSourceFonts = true;
        });
      },
    );
  }
})();
