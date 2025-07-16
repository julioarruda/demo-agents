import React from 'react';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import CustomerRegistration from './CustomerRegistration';

describe('CustomerRegistration', () => {
  beforeEach(() => {
    render(<CustomerRegistration />);
  });

  test('renders registration form with all required fields', () => {
    expect(screen.getByRole('heading', { name: /cadastro de clientes/i })).toBeInTheDocument();
    expect(screen.getByLabelText(/^nome \*/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/^sobrenome \*/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/^email \*/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/^cep \*/i)).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /cadastrar cliente/i })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /limpar formulário/i })).toBeInTheDocument();
  });

  test('shows validation errors when form is submitted empty', async () => {
    fireEvent.click(screen.getByRole('button', { name: /cadastrar cliente/i }));

    await waitFor(() => {
      expect(screen.getByText('Nome é obrigatório')).toBeInTheDocument();
      expect(screen.getByText('Sobrenome é obrigatório')).toBeInTheDocument();
      expect(screen.getByText('Email é obrigatório')).toBeInTheDocument();
      expect(screen.getByText('CEP é obrigatório')).toBeInTheDocument();
    });
  });

  test('clears form when clear button is clicked', async () => {
    // Fill the form
    fireEvent.change(screen.getByLabelText(/^nome \*/i), { target: { value: 'João' } });
    fireEvent.change(screen.getByLabelText(/^sobrenome \*/i), { target: { value: 'Silva' } });
    fireEvent.change(screen.getByLabelText(/^email \*/i), { target: { value: 'joao@email.com' } });
    fireEvent.change(screen.getByLabelText(/^cep \*/i), { target: { value: '12345-678' } });

    // Clear the form
    fireEvent.click(screen.getByRole('button', { name: /limpar formulário/i }));

    // Check if fields are empty
    expect(screen.getByLabelText(/^nome \*/i)).toHaveValue('');
    expect(screen.getByLabelText(/^sobrenome \*/i)).toHaveValue('');
    expect(screen.getByLabelText(/^email \*/i)).toHaveValue('');
    expect(screen.getByLabelText(/^cep \*/i)).toHaveValue('');
  });

  test('shows success message after successful form submission', async () => {
    // Fill the form with valid data
    fireEvent.change(screen.getByLabelText(/^nome \*/i), { target: { value: 'João' } });
    fireEvent.change(screen.getByLabelText(/^sobrenome \*/i), { target: { value: 'Silva' } });
    fireEvent.change(screen.getByLabelText(/^email \*/i), { target: { value: 'joao@email.com' } });
    fireEvent.change(screen.getByLabelText(/^cep \*/i), { target: { value: '12345-678' } });

    // Submit the form
    fireEvent.click(screen.getByRole('button', { name: /cadastrar cliente/i }));

    // Check for success message
    await waitFor(() => {
      expect(screen.getByText(/cliente cadastrado com sucesso/i)).toBeInTheDocument();
      expect(screen.getByText(/João Silva/)).toBeInTheDocument();
      expect(screen.getByText(/joao@email.com/)).toBeInTheDocument();
      expect(screen.getByText(/12345-678/)).toBeInTheDocument();
    });
  });

  test('returns to form when "Cadastrar Novo Cliente" is clicked', async () => {
    // Fill and submit form first
    fireEvent.change(screen.getByLabelText(/^nome \*/i), { target: { value: 'João' } });
    fireEvent.change(screen.getByLabelText(/^sobrenome \*/i), { target: { value: 'Silva' } });
    fireEvent.change(screen.getByLabelText(/^email \*/i), { target: { value: 'joao@email.com' } });
    fireEvent.change(screen.getByLabelText(/^cep \*/i), { target: { value: '12345-678' } });
    fireEvent.click(screen.getByRole('button', { name: /cadastrar cliente/i }));

    // Wait for success message
    await waitFor(() => {
      expect(screen.getByText(/cliente cadastrado com sucesso/i)).toBeInTheDocument();
    });

    // Click "Cadastrar Novo Cliente"
    fireEvent.click(screen.getByRole('button', { name: /cadastrar novo cliente/i }));

    // Check if form is back
    await waitFor(() => {
      expect(screen.getByRole('heading', { name: /cadastro de clientes/i })).toBeInTheDocument();
      expect(screen.getByLabelText(/^nome \*/i)).toHaveValue('');
    });
  });

  test('validates email format', async () => {
    fireEvent.change(screen.getByLabelText(/^nome \*/i), { target: { value: 'João' } });
    fireEvent.change(screen.getByLabelText(/^sobrenome \*/i), { target: { value: 'Silva' } });
    fireEvent.change(screen.getByLabelText(/^email \*/i), { target: { value: 'invalid-email' } });
    fireEvent.change(screen.getByLabelText(/^cep \*/i), { target: { value: '12345-678' } });

    fireEvent.click(screen.getByRole('button', { name: /cadastrar cliente/i }));

    await waitFor(() => {
      expect(screen.getByText('Email deve ter um formato válido')).toBeInTheDocument();
    });
  });

  test('validates CEP format', async () => {
    fireEvent.change(screen.getByLabelText(/^nome \*/i), { target: { value: 'João' } });
    fireEvent.change(screen.getByLabelText(/^sobrenome \*/i), { target: { value: 'Silva' } });
    fireEvent.change(screen.getByLabelText(/^email \*/i), { target: { value: 'joao@email.com' } });
    fireEvent.change(screen.getByLabelText(/^cep \*/i), { target: { value: '123' } });

    fireEvent.click(screen.getByRole('button', { name: /cadastrar cliente/i }));

    await waitFor(() => {
      expect(screen.getByText('CEP deve ter o formato 12345-678')).toBeInTheDocument();
    });
  });
});