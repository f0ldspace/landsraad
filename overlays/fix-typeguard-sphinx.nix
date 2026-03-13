final: prev: {
  pythonPackagesExtensions = (prev.pythonPackagesExtensions or [ ]) ++ [
    (pyFinal: pyPrev: {
      sphinx = pyPrev.sphinx.overridePythonAttrs (old: {
        disabled = false;
      });
    })
  ];
}
