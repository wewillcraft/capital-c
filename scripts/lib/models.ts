export type User = {
  id: string;
  email: string;
};

export type Tenant = {
  id: string;
  namespace: string;
  name: string;
  created_at: Date;
  status: string;
  applied_migrations: string[];
};
