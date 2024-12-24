document.addEventListener('DOMContentLoaded', function () {
  let progress = 0;
  let progressInterval = null;

  const percentageEl = document.querySelector(".percentage");
  const circularProgress = document.querySelector(".circular-progress .progress");
  const progressFill = document.querySelector(".progress-bar .progress-fill");
  const titleEl = document.getElementById("title");
  const subtitleEl = document.getElementById("subtitle");

  function updateProgress(duration) {
    const interval = 100;
    const step = (interval / duration) * 100;

    progressInterval = setInterval(() => {
      progress += step;
      if (progress >= 100) {
        progress = 100;
        clearInterval(progressInterval);
        sendCompletion();
      }
      percentageEl.textContent = `${Math.floor(progress)}%`;
      const offset = 219.91 - (219.91 * progress) / 100;
      circularProgress.style.strokeDashoffset = offset;
      progressFill.style.width = `${progress}%`;
    }, interval);
  }

  function sendCompletion() {
    $.post(`https://${GetParentResourceName()}/progressComplete`, JSON.stringify({}), () => {
      document.body.classList.add("hidden");
    });
  }

  function cancelProgress() {
    clearInterval(progressInterval); 
    document.body.classList.add("hidden"); 
  }

  window.addEventListener("message", (event) => {
    const data = event.data;

    if (data.type === "progress") {
      progress = 0; 
      clearInterval(progressInterval);
      document.body.classList.remove("hidden");
      titleEl.textContent = data.title || "Loading...";
      subtitleEl.textContent = data.description || "Please wait...";
      updateProgress(data.duration);
    }

    if (data.type === "cancelProgress") {
      cancelProgress(); 
    }
  });
});
