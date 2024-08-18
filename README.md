# DevOps Challenge

Este projeto consiste em criar e configurar uma infraestrutura na AWS usando Terraform e configurar uma pipeline de CI/CD com GitHub Actions.

## Tecnologias Utilizadas
- Terraform
- AWS (EC2, VPC, Security Groups)
- GitHub Actions
- Nginx

## Como Executar o Projeto
1. Clone o repositório.
2. Configure suas credenciais da AWS.
3. Execute `terraform init` e `terraform apply`.

## To-Do: Implementação de Monitoramento

Uma próxima etapa para aprimorar esta infraestrutura seria a implementação de um sistema de monitoramento usando Prometheus e Grafana. O objetivo é garantir a visibilidade do desempenho da aplicação e dos recursos da infraestrutura.

### Passos para Implementação:
1. **Criar uma Nova Instância EC2**:
   - Provisionar uma nova instância EC2 para rodar o Prometheus e o Grafana.
   - A instância deve ser configurada em uma sub-rede pública com um grupo de segurança adequado.

2. **Configurar Prometheus**:
   - Instalar e configurar o Prometheus na nova instância para coletar métricas dos servidores e dos serviços em execução.
   - Configurar o Prometheus para monitorar o Nginx na instância principal e outras métricas relevantes.

3. **Configurar Grafana**:
   - Instalar o Grafana na mesma instância e conectá-lo ao Prometheus como fonte de dados.
   - Criar dashboards personalizados para visualizar as métricas monitoradas.

4. **Integrar com a Pipeline CI/CD**:
   - Adicionar o novo código Terraform ao repositório para automatizar a criação da instância de monitoramento.
   - Incluir as configurações necessárias para que a pipeline do GitHub Actions possa aplicar essas mudanças.

This is a challenge by Coodesh.
