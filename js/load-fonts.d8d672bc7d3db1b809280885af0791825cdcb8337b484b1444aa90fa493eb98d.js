(function () {
  if ("fonts" in document) {
    if (sessionStorage.fontsLoadedAnthesisFonts) {
      document.documentElement.className += " fonts-loaded-2";
      return;
    }

    const stage1Promises = [
      "1rem 'Anthesis Gravitas Sans Faux'",
      "1rem 'Anthesis Legible Sans Faux'",
      "1rem 'Anthesis Legible Mono Faux'",
    ];
    const stage2Promises = [
      "1rem 'Anthesis Gravitas Sans'",
      "1rem 'Anthesis Legible Sans'",
      "1rem 'Anthesis Legible Mono'",
      "italic 1rem 'Anthesis Gravitas Sans'",
      "italic 1rem 'Anthesis Legible Sans'",
      "italic 1rem 'Anthesis Legible Mono'",
    ];

    Promise.all(stage1Promises.map((font) => document.fonts.load(font))).then(
      function () {
        document.documentElement.className += " fonts-loaded-1";

        Promise.all(
          stage2Promises.map((font) => document.fonts.load(font)),
        ).then(function () {
          document.documentElement.className += " fonts-loaded-2";
          sessionStorage.fontsLoadedAnthesisFonts = true;
        });
      },
    );
  }
})();
