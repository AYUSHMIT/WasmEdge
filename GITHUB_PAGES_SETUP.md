# Setting Up GitHub Pages for WasmEdge Demo

This guide explains how to enable GitHub Pages to publish the demo site.

## Prerequisites

- Repository with the demo branch (`copilot/create-demo-site-for-wasmedge`)
- Repository permissions to enable GitHub Pages
- GitHub Actions enabled

## Steps to Enable GitHub Pages

### 1. Merge the Demo Branch

First, merge the demo branch into your main branch or keep it separate:

```bash
# Option 1: Merge to main (recommended)
git checkout main
git merge copilot/create-demo-site-for-wasmedge
git push origin main

# Option 2: Keep as separate branch and deploy from it
# No action needed, just ensure the workflow runs on the branch
```

### 2. Enable GitHub Pages

1. Go to your repository on GitHub: `https://github.com/AYUSHMIT/WasmEdge`
2. Click on **Settings**
3. Scroll down to **Pages** in the left sidebar
4. Under **Source**, select:
   - **Source**: `Deploy from a branch`
   - **Branch**: `gh-pages`
   - **Folder**: `/ (root)`
5. Click **Save**

### 3. Trigger the Workflow

The GitHub Actions workflow will automatically run when you push to the demo branch. You can also manually trigger it:

1. Go to **Actions** tab
2. Select **Demo Build and Site Deploy** workflow
3. Click **Run workflow**
4. Select the branch (`copilot/create-demo-site-for-wasmedge`)
5. Click **Run workflow**

### 4. Wait for Deployment

The workflow will:
1. Build WasmEdge from source
2. Build all demo examples (Rust and C)
3. Generate visualizations
4. Build the MkDocs site
5. Deploy to `gh-pages` branch

This typically takes 15-20 minutes for the first run.

### 5. Access Your Demo Site

Once deployed, your site will be available at:

```
https://ayushmit.github.io/WasmEdge/
```

## Verifying Deployment

### Check Workflow Status

1. Go to **Actions** tab
2. Find the latest **Demo Build and Site Deploy** run
3. Ensure all steps completed successfully (green checkmarks)

### Check GitHub Pages Status

1. Go to **Settings** → **Pages**
2. You should see: "Your site is live at https://ayushmit.github.io/WasmEdge/"

### Browse the Site

Navigate to your site and verify:
- Home page loads
- Architecture diagrams display
- Demo pages are accessible
- Visualizations render correctly

## Troubleshooting

### Workflow Fails

**Check the logs:**
1. Go to **Actions** tab
2. Click on the failed workflow run
3. Expand the failed step to see error messages

**Common issues:**
- Missing permissions: Ensure GitHub Actions has write permissions
- Build failures: Check that all dependencies are installed correctly
- Deployment failures: Verify the `gh-pages` branch exists and is accessible

### Site Not Updating

1. **Clear browser cache**: Use Ctrl+F5 (Cmd+Shift+R on Mac)
2. **Check deployment time**: It may take a few minutes for changes to propagate
3. **Verify workflow completed**: Ensure the deploy job finished successfully
4. **Check gh-pages branch**: Visit `https://github.com/AYUSHMIT/WasmEdge/tree/gh-pages` to see deployed files

### Pages Not Enabled

If you see "GitHub Pages is not available for this repository":
- Ensure the repository is public, or you have GitHub Pro/Team
- Check repository settings permissions
- Verify Actions are enabled

## Local Development

### Build Locally

```bash
# Install dependencies
python3 -m pip install mkdocs mkdocs-material

# Build the site
mkdocs build

# Serve locally for development
mkdocs serve
```

Then visit: http://127.0.0.1:8000/

### Test Examples Locally

```bash
# Install Rust and add wasm32-wasip1 target
rustup target add wasm32-wasip1

# Build examples
./demo/scripts/build_examples.sh

# Run examples (requires WasmEdge installed)
./demo/scripts/run_examples.sh

# Generate visualizations
./demo/scripts/generate_visuals.sh
```

## Customization

### Update Site Theme

Edit `mkdocs.yml` to customize:
- Site name and description
- Theme colors
- Navigation structure
- Extensions and plugins

### Add More Examples

1. Create new example directory under `demo/examples/`
2. Add build commands to `demo/scripts/build_examples.sh`
3. Add run commands to `demo/scripts/run_examples.sh`
4. Create documentation in `docs/demos/`
5. Update `mkdocs.yml` navigation

### Modify Visualizations

Edit Python scripts in `demo/scripts/`:
- `generate_language_chart.py` - Language composition
- `generate_architecture.py` - Architecture diagram
- `generate_performance_chart.py` - Performance comparison

## Maintenance

### Update Content

1. Edit markdown files in `docs/`
2. Commit and push changes
3. Workflow automatically rebuilds and deploys

### Update Examples

1. Modify example code
2. Test locally with `build_examples.sh`
3. Commit and push
4. Workflow rebuilds examples and site

### Update WasmEdge Version

Edit `.github/workflows/demo-build.yml` to:
- Use specific WasmEdge release tag
- Modify build options
- Update dependencies

## Resources

- [MkDocs Documentation](https://www.mkdocs.org/)
- [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [WasmEdge Official Site](https://wasmedge.org/)

## Support

For issues with:
- **Demo site content**: Open an issue in this repository
- **WasmEdge runtime**: Visit [WasmEdge/WasmEdge](https://github.com/WasmEdge/WasmEdge)
- **GitHub Pages**: Consult [GitHub Pages docs](https://docs.github.com/en/pages)
