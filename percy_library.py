import percy
#not working yet
def setup_percy():
    # Build a ResourceLoader that knows how to collect assets for this application.
    root_static_dir = os.path.join(os.path.dirname(__file__), 'static')
    loader = percy.ResourceLoader(
        root_dir=root_static_dir,
        # Prepend `/assets` to all of the files in the static directory, to match production assets.
        # This is only needed if your static assets are served from a nested directory.
        base_url='/assets',
        webdriver=webdriver,
    )
    percy_runner = percy.Runner(loader=loader)
    percy_runner.initialize_build()
    return percy_runner

def run_percy(percy_runner, name)
    webdriver.get(self.live_server_url)
    percy_runner.snapshot(name)

def stop_percy(percy_runner):
    percy_runner.finalize_build()