import React, { useState } from 'react';
import './CustomerRegistration.css';

interface CustomerData {
  nome: string;
  sobrenome: string;
  email: string;
  cep: string;
}

interface ValidationErrors {
  nome?: string;
  sobrenome?: string;
  email?: string;
  cep?: string;
}

const CustomerRegistration: React.FC = () => {
  const [customerData, setCustomerData] = useState<CustomerData>({
    nome: '',
    sobrenome: '',
    email: '',
    cep: ''
  });

  const [errors, setErrors] = useState<ValidationErrors>({});
  const [isSubmitted, setIsSubmitted] = useState(false);

  const validateEmail = (email: string): boolean => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  };

  const validateCEP = (cep: string): boolean => {
    // Brazilian CEP format: 12345-678 or 12345678
    const cepRegex = /^\d{5}-?\d{3}$/;
    return cepRegex.test(cep);
  };

  const validateForm = (): boolean => {
    const newErrors: ValidationErrors = {};

    if (!customerData.nome.trim()) {
      newErrors.nome = 'Nome é obrigatório';
    }

    if (!customerData.sobrenome.trim()) {
      newErrors.sobrenome = 'Sobrenome é obrigatório';
    }

    if (!customerData.email.trim()) {
      newErrors.email = 'Email é obrigatório';
    } else if (!validateEmail(customerData.email)) {
      newErrors.email = 'Email deve ter um formato válido';
    }

    if (!customerData.cep.trim()) {
      newErrors.cep = 'CEP é obrigatório';
    } else if (!validateCEP(customerData.cep)) {
      newErrors.cep = 'CEP deve ter o formato 12345-678';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleInputChange = (field: keyof CustomerData, value: string) => {
    setCustomerData(prev => ({
      ...prev,
      [field]: value
    }));

    // Clear error when user starts typing
    if (errors[field]) {
      setErrors(prev => ({
        ...prev,
        [field]: undefined
      }));
    }
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    if (validateForm()) {
      setIsSubmitted(true);
      console.log('Cliente cadastrado:', customerData);
      // Here you would typically send the data to a backend service
    }
  };

  const handleReset = () => {
    setCustomerData({
      nome: '',
      sobrenome: '',
      email: '',
      cep: ''
    });
    setErrors({});
    setIsSubmitted(false);
  };

  if (isSubmitted) {
    return (
      <div className="customer-registration">
        <div className="success-message">
          <h2>✅ Cliente Cadastrado com Sucesso!</h2>
          <div className="customer-details">
            <p><strong>Nome:</strong> {customerData.nome} {customerData.sobrenome}</p>
            <p><strong>Email:</strong> {customerData.email}</p>
            <p><strong>CEP:</strong> {customerData.cep}</p>
          </div>
          <button onClick={handleReset} className="btn btn-primary">
            Cadastrar Novo Cliente
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="customer-registration">
      <h1>Cadastro de Clientes</h1>
      <form onSubmit={handleSubmit} className="registration-form">
        <div className="form-group">
          <label htmlFor="nome">Nome *</label>
          <input
            type="text"
            id="nome"
            value={customerData.nome}
            onChange={(e) => handleInputChange('nome', e.target.value)}
            className={errors.nome ? 'error' : ''}
            placeholder="Digite seu nome"
          />
          {errors.nome && <span className="error-message">{errors.nome}</span>}
        </div>

        <div className="form-group">
          <label htmlFor="sobrenome">Sobrenome *</label>
          <input
            type="text"
            id="sobrenome"
            value={customerData.sobrenome}
            onChange={(e) => handleInputChange('sobrenome', e.target.value)}
            className={errors.sobrenome ? 'error' : ''}
            placeholder="Digite seu sobrenome"
          />
          {errors.sobrenome && <span className="error-message">{errors.sobrenome}</span>}
        </div>

        <div className="form-group">
          <label htmlFor="email">Email *</label>
          <input
            type="email"
            id="email"
            value={customerData.email}
            onChange={(e) => handleInputChange('email', e.target.value)}
            className={errors.email ? 'error' : ''}
            placeholder="Digite seu email"
          />
          {errors.email && <span className="error-message">{errors.email}</span>}
        </div>

        <div className="form-group">
          <label htmlFor="cep">CEP *</label>
          <input
            type="text"
            id="cep"
            value={customerData.cep}
            onChange={(e) => handleInputChange('cep', e.target.value)}
            className={errors.cep ? 'error' : ''}
            placeholder="12345-678"
            maxLength={9}
          />
          {errors.cep && <span className="error-message">{errors.cep}</span>}
        </div>

        <div className="form-actions">
          <button type="submit" className="btn btn-primary">
            Cadastrar Cliente
          </button>
          <button type="button" onClick={handleReset} className="btn btn-secondary">
            Limpar Formulário
          </button>
        </div>
      </form>
    </div>
  );
};

export default CustomerRegistration;