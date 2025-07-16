import React from 'react';
import { render, screen } from '@testing-library/react';
import App from './App';

test('renders customer registration form', () => {
  render(<App />);
  const headingElement = screen.getByRole('heading', { name: /cadastro de clientes/i });
  expect(headingElement).toBeInTheDocument();
});
