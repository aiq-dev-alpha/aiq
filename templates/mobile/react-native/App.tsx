import React from 'react';
import { Provider } from 'react-redux';
import { PersistGate } from 'redux-persist/integration/react';
import { store, persistor } from '@/store';
import { AppNavigator } from '@/navigation';
import { Loading } from '@/components';

const App: React.FC = () => {
  return (
    <Provider store={store}>
      <PersistGate loading={<Loading text="Loading app..." />} persistor={persistor}>
        <AppNavigator />
      </PersistGate>
    </Provider>
  );
};

export default App;