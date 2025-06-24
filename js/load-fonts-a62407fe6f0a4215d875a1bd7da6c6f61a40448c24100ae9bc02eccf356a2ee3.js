(function () {
  if ("fonts" in document) {
    if (sessionStorage.fontsLoadedSourceFonts) {
      document.documentElement.className += " fonts-loaded-2";
      return;
    }

    const stage1Promises = [
      "1rem 'Atkinson Hyperlegible Next Faux'",
      "1rem 'Atkinson Hyperlegible Mono Faux'",
    ];
    const stage2Promises = [
      "1rem 'Atkinson Hyperlegible Next'",
      "1rem 'Atkinson Hyperlegible Mono'",
      "italic 1rem 'Atkinson Hyperlegible Next'",
      "italic 1rem 'Atkinson Hyperlegible Mono'",
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
