import { NativeModules, NativeEventEmitter } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';

// Native modules
const { DSRuntimeNative } = NativeModules;
const dsRuntimeEmitter = new NativeEventEmitter(DSRuntimeNative);

class DSRuntime {
  private static instance: DSRuntime;

  private constructor() {
    // Initialize listeners for native events
    this.initEventListeners();
  }

  public static getInstance(): DSRuntime {
    if (!DSRuntime.instance) {
      DSRuntime.instance = new DSRuntime();
    }
    return DSRuntime.instance;
  }

  private initEventListeners() {
    dsRuntimeEmitter.addListener('ScreenTintEvent', this.handleScreenTintEvent);
    dsRuntimeEmitter.addListener('NotificationEvent', this.handleNotificationEvent);
    // Add more event listeners as needed
  }

  private handleScreenTintEvent = (data: any) => {
    // Handle screen tinting logic
  };

  private handleNotificationEvent = (data: any) => {
    // Handle notification logic
  };

  public async setSetting(key: string, value: any) {
    await AsyncStorage.setItem(key, JSON.stringify(value));
    // Notify native modules of setting change if necessary
    DSRuntimeNative.updateSetting(key, value);
  }

  public async getSetting(key: string) {
    const value = await AsyncStorage.getItem(key);
    return value ? JSON.parse(value) : null;
  }
}

// Export singleton instance
export default DSRuntime.getInstance();
