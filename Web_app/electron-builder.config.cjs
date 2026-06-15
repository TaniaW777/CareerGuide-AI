/**
 * @type {import('electron-builder').Configuration}
 * @see https://www.electron.build/configuration/configuration
 */
const config = {
  appId: 'com.careerguide.ai',
  productName: 'CareerGuide IA',
  directories: {
    output: 'release/${version}',
    buildResources: 'public',
  },
  files: [
    'dist',
    'dist-electron',
  ],
  win: {
    target: [
      {
        target: 'nsis',
        arch: ['x64'],
      },
    ],
    icon: 'public/favicon.ico',
  },
  nsis: {
    oneClick: false,
    perMachine: false,
    allowToChangeInstallationDirectory: true,
    deleteAppDataOnUninstall: false,
  },
};

module.exports = config;
